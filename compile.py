import os
import sys
import argparse
import shutil
import platform
import pathlib
import shutil
import json
import subprocess
import signal


def crtl_c_exit(sig, frame):
    print('You pressed Ctrl+C! Exiting')
    sys.exit(0)
signal.signal(signal.SIGINT, crtl_c_exit)


def checkPythonVersion():
    if sys.version_info.major < 3: # python 3 must be the runtime
        raise Exception("%s must be executed using Python 3" % (os.path.basename(__file__)))


def query_yes_no(question, default="yes"):
    valid = {"yes": True, "y": True, "ye": True, "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = None

        # python 3 versus python 2 shenanigans
        if sys.version_info.major < 3:
            choice = raw_input().lower()
        else:
            choice = input().lower()

        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' (or 'y' or 'n').\n")


def docker_container_reset(container, container_tag):
    print("resetting docker container %s with name %s" % (container, container_tag))
    os.system("docker container stop %s" % (container))
    os.system("docker container rm %s " % (container))
    os.system("docker create -it --name %s %s" % (container, container_tag))
    os.system("docker container start %s" % (container))


def docker_container_cleanup(container):
    print("Performing cleanup of docker resources ...")
    os.system("docker container stop %s" % (container))
    os.system("docker container rm %s" % (container))
    print("ok")



def docker_get_path_object(dir):
    dir_abs = os.path.abspath(dir)
    nativeDirObj = pathlib.Path(str(dir_abs))
    posixDirObj = pathlib.PurePosixPath((nativeDirObj.root/(nativeDirObj.relative_to(nativeDirObj.anchor))).as_posix())
    posixDirObj = pathlib.PurePosixPath(pathlib.PurePosixPath(str(posixDirObj)).as_posix().replace(' ', ' ').lstrip().rstrip())
    return posixDirObj


def docker_mirror_workdir(container):
    current_dir = os.getcwd()
    docker_current_dir_object = docker_get_path_object(current_dir)
    docker_current_dir_str = str(docker_current_dir_object)
    os.system("docker exec -t %s mkdir -p \"%s\"" % (container, docker_current_dir_str))


def copy_dir_to_docker(container, dir):
    if os.path.exists(dir):
        if os.path.isdir(dir):
            docker_dir_object = docker_get_path_object(dir)
            docker_dir_str = str(docker_dir_object)
            os.system("docker cp \"%s\" %s:\"%s\"" % (dir, container, docker_dir_str))
        else:
            print("Error: dir %s exists but is not a directory" % (dir))
            exit(-1)
    else:
        print("Error: dir %s does not exist" % (dir))
        exit(-1)


def copy_dir_from_docker(container, dir):
    docker_dir_object = docker_get_path_object(dir)
    docker_dir_str = str(docker_dir_object)
    dir_abs = os.path.abspath(dir)
    os.system("docker cp %s:\"%s\" %s" % (container, docker_dir_str, dir_abs))


def copy_build_tree_to_docker(container, build_dir):
    print("Copying build tree %s from local machine to docker container" % (build_dir))
    copy_dir_to_docker(container, build_dir)


def copy_source_tree_to_docker(container, source_dir):
    docker_source_dir_object = docker_get_path_object(source_dir)
    docker_build_dir_object = docker_get_path_object(build_dir)
    docker_source_dir_str = str(docker_source_dir_object)
    docker_build_dir_str = str(docker_build_dir_object)
    copy_dir_to_docker(container, source_dir)

    if docker_source_dir_object in docker_build_dir_object.parents:
        print("\nBuild tree %s is a subdirectory of source tree %s. Removing...\n" % (docker_build_dir_str, docker_source_dir_str))
        os.system("docker exec -t \"%s\" rm -rf %s" % (container, docker_build_dir_str))


def copy_build_tree_from_docker(container, build_dir):
    print("Copying build tree %s from docker container to local machine" % (build_dir))
    copy_dir_from_docker(container, build_dir)


def docker_build_project(source_dir, build_root, build_script, container, cross=False, release=False, ):
    build_dir = build_root

    docker_build_script_path_object = docker_get_path_object(build_script)
    docker_build_script_path_str = str(docker_build_script_path_object)
    build_command="python3 %s" % (docker_build_script_path_str)
    
    docker_mirror_workdir(container)
    copy_source_tree_to_docker(container, source_dir)
    
    arch_dir=None
    config_dir=None
    if(cross):
        build_command += " %s " % ("--cross")
        arch_dir = "cross"
    else:
        arch_dir = "host"
    
    if(release):
        build_command += " %s " % ("--release")
        config_dir = "release"
    else:
        config_dir = "debug"
    build_dir = os.path.join(build_root, arch_dir, config_dir)

    docker_build_dir_object = docker_get_path_object(build_dir)
    docker_build_dir_str = str(docker_build_dir_object)
    build_command += " --build_dir %s " % (docker_build_dir_str)

    print("build_command = %s " % (build_command))

    if os.path.exists(build_dir):
        if(os.path.isdir(build_dir)):
            print("Copying build tree %s into docker container %s before building object deltas... " % (build_dir, container))
            copy_build_tree_to_docker(container, build_dir)

    docker_source_dir_object = docker_get_path_object(source_dir)
    docker_source_dir_str = str(docker_source_dir_object)
    build_command += " --source_dir %s " % (docker_source_dir_str)
    
    
    os.system("docker exec -t \"%s\" %s" % (container, build_command))

    #os.system("docker exec -t \"%s\" ls %s/build" % (container, docker_source_dir_str))
        
    copy_build_tree_from_docker(container, build_dir)
    


# COMMENTED OUT FOR NOW
'''
# This updates the vscode intellisense file compile_commands.json emitted in the docker container 
# to work on the native path
# the compiler toolchain arm-none-eabi-gcc should be present in the user's PATH (absolute, executable, hardlink, or symlink)
# the compiler toolchain sysroot must also be present somewhere in the user's system
def update_intellisense(PathLibObject, old_dir, new_dir):
    if PathLibObject.exists():
        if PathLibObject.is_file():
            text = PathLibObject.read_text()
            compileCommandsJsonObject = json.loads(text)
            for command in compileCommandsJsonObject:
                for key in command.keys():
                    command[key] = str(command[key]).replace(old_dir, new_dir)
                    if key == "command":
                        tmp = str(command[key])
                        compilerPathObj = pathlib.Path(tmp.split(' ', 1)[0])
                        oldCompilerPath = compilerPathObj.as_posix()
                        newCompilerPath = compilerPathObj.name
                        tmp = tmp.replace(oldCompilerPath, newCompilerPath)
                        command[key] = tmp
            PathLibObject.write_text(json.dumps(indent=2, obj=compileCommandsJsonObject))
        else:
            print("%s exists but is NOT a file" % (str(PathLibObject)))
    else:
        print("%s does not exist so could not configure intellisense." % (str(PathLibObject)))
'''




if __name__ == "__main__":
    checkPythonVersion() 
    if platform.system() != "Windows" and platform.system() != "Linux":
        print(nameOfThisFile + " only supports builds from Windows or Linux environments")
        exit(1)
    
    # configure CLI args
    parser = argparse.ArgumentParser(description="parse command line args for docker build script")
    parser.add_argument("--output_dir", action="store", dest="output_dir", default="bin", help="The output directory name for compiled binaries")
    parser.add_argument("--release", action="store_true", dest="release_build", help="Build the project as a release build")
    parser.add_argument("--build_dir", action="store", dest="build_dir", default="build", help="directory name in which to generate the cmake build pipeline")
    parser.add_argument("--source_dir", action="store", dest="source_dir", default=".", help="the name of the directory containing top-level CMakeLists.txt")
    parser.add_argument("--image_repo", action="store", dest="docker_repo", default="local_images", help="docker image repository to contain the docker image nametag")
    parser.add_argument("--image_tag", action="store", dest="docker_nametag", default="cmake_docker_build_image", help="the name of the docker image")
    parser.add_argument("--verbose", action="store", dest="build_verbose", default=False, help="Whether the build should be performed using a verbose makefile")
    parser.add_argument("--prompt_overwrite", action="store", dest="prompt_overwrite", default=False, help="Ignore warning prompts when overwriting output and build directories")
    parser.add_argument("--image", action="store", dest="image_file", default=None, help="instead of building a docker image, load a docker build image")
    parser.add_argument("--clean", action="store", dest="build_clean", default=False, help="rebuild all source files instead of just deltas")

    # parse CLI args
    args = parser.parse_args()
    
    build_dir = args.build_dir
    source_dir = args.source_dir

    release_build = args.release_build
    docker_tag   = "%s:%s" % (args.docker_repo, args.docker_nametag)
    docker_image_filename = "%s_%s" % (args.docker_repo, args.docker_nametag)
    scripts_dir = "scripts"
    container = "cmake_build_container"
    build_verbose = args.build_verbose
    prompt_overwrite = args.prompt_overwrite
    image_file = args.image_file
    build_clean = args.build_clean

    if image_file != None:
        os.system("docker load -i %s" % (image_file))  # load docker image from file
    else:
        os.system("docker build . -t %s" % (docker_tag)) # build docker image from scatch (or from cache)


    # validate CLI args
    if not os.path.exists(source_dir):
        print("[ERROR] source path %s does not exist" % (str(source_dir)))
        exit(1)
    else:
        if not os.path.isdir(source_dir):
            print("[ERROR] source path %s exists but is not a directory " % (str(source_dir)))
            exit(1)

    if os.path.exists(build_dir):
        if os.path.isdir(build_dir):
            if prompt_overwrite:
                should_continue = query_yes_no("[WARNING] build directory: %s exists and will be overwritten post-build. Continue?" % (build_dir), "yes")
                if not should_continue:
                    print("Aborting...")
                    exit(0)

    docker_container_reset(container, docker_tag)

    docker_build_project(source_dir, build_dir, "scripts/build.py", container, cross=False, release=False)
    #docker_build_project(source_dir, build_dir, "scripts/build.py", container, cross=False, release=True)
    #docker_build_project(source_dir, build_dir, "scripts/build.py", container, cross=True, release=False)
    #docker_build_project(source_dir, build_dir, "scripts/build.py", container, cross=True, release=True)

    


'''
    ## THIS NEXT SECTION IS MODIFYING THE EXPORTED JSON SO THAT INTELLISENSE WORKS ON THE NATIVE PLATFORM
    nativeCompileCommandsPathObj = nativeBuildDirPathObj/pathlib.Path("compile_commands.json")
    oldPath = str(posixCurrentDirPathObj)
    newPath = nativeCurrentDirPathObj.drive + oldPath
    update_intellisense(nativeCompileCommandsPathObj, oldPath, newPath)
'''