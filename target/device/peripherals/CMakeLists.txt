cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_library(${PROJECT_NAME}-device-peripherals)
target_include_directories(${PROJECT_NAME}-device-peripherals
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Legacy/>
)

target_sources(${PROJECT_NAME}-device-peripherals 
    PRIVATE
        src/stm32f4xx_hal_ltdc.c          
        src/stm32f4xx_hal_sdram.c                         
        src/stm32f4xx_ll_fmc.c
        src/stm32f4xx_hal_exti.c           
        src/stm32f4xx_hal_ltdc_ex.c       
        src/stm32f4xx_hal_smartcard.c                     
        src/stm32f4xx_ll_fmpi2c.c
        src/stm32f4xx_hal_adc.c      
        src/stm32f4xx_hal_flash.c          
        src/stm32f4xx_hal_mmc.c           
        src/stm32f4xx_hal_smbus.c                         
        src/stm32f4xx_ll_fsmc.c
        src/stm32f4xx_hal_adc_ex.c   
        src/stm32f4xx_hal_flash_ex.c       
        src/stm32f4xx_hal_spdifrx.c                       
        src/stm32f4xx_ll_gpio.c
        src/stm32f4xx_hal.c          
        src/stm32f4xx_hal_flash_ramfunc.c  
        src/stm32f4xx_hal_nand.c          
        src/stm32f4xx_hal_spi.c                           
        src/stm32f4xx_ll_i2c.c
        src/stm32f4xx_hal_can.c      
        src/stm32f4xx_hal_fmpi2c.c         
        src/stm32f4xx_hal_nor.c           
        src/stm32f4xx_hal_sram.c                          
        src/stm32f4xx_ll_lptim.c
        src/stm32f4xx_hal_cec.c      
        src/stm32f4xx_hal_fmpi2c_ex.c      
        src/stm32f4xx_hal_pccard.c        
        src/stm32f4xx_hal_tim.c                           
        src/stm32f4xx_ll_pwr.c
        src/stm32f4xx_hal_cortex.c   
        src/stm32f4xx_hal_fmpsmbus.c       
        src/stm32f4xx_hal_pcd.c           
        src/stm32f4xx_ll_rcc.c
        src/stm32f4xx_hal_crc.c      
        src/stm32f4xx_hal_fmpsmbus_ex.c    
        src/stm32f4xx_hal_pcd_ex.c        
        src/stm32f4xx_ll_rng.c
        src/stm32f4xx_hal_cryp.c     
        src/stm32f4xx_hal_gpio.c           
        src/stm32f4xx_hal_pwr.c           
        src/stm32f4xx_ll_rtc.c
        src/stm32f4xx_hal_cryp_ex.c  
        src/stm32f4xx_hal_hash.c           
        src/stm32f4xx_hal_pwr_ex.c        
        src/stm32f4xx_hal_tim_ex.c                        
        src/stm32f4xx_ll_sdmmc.c
        src/stm32f4xx_hal_dac.c      
        src/stm32f4xx_hal_hash_ex.c        
        src/stm32f4xx_hal_qspi.c          
        src/stm32f4xx_hal_uart.c                          
        src/stm32f4xx_ll_spi.c
        src/stm32f4xx_hal_dac_ex.c   
        src/stm32f4xx_hal_hcd.c            
        src/stm32f4xx_hal_rcc.c           
        src/stm32f4xx_hal_usart.c                         
        src/stm32f4xx_ll_tim.c
        src/stm32f4xx_hal_dcmi.c     
        src/stm32f4xx_hal_i2c.c            
        src/stm32f4xx_hal_rcc_ex.c        
        src/stm32f4xx_hal_wwdg.c                          
        src/stm32f4xx_ll_usart.c
        src/stm32f4xx_hal_dcmi_ex.c  
        src/stm32f4xx_hal_i2c_ex.c         
        src/stm32f4xx_hal_rng.c           
        src/stm32f4xx_ll_adc.c                            
        src/stm32f4xx_ll_usb.c
        src/stm32f4xx_hal_dfsdm.c    
        src/stm32f4xx_hal_i2s.c            
        src/stm32f4xx_hal_rtc.c           
        src/stm32f4xx_ll_crc.c                            
        src/stm32f4xx_ll_utils.c
        src/stm32f4xx_hal_dma2d.c    
        src/stm32f4xx_hal_i2s_ex.c         
        src/stm32f4xx_hal_rtc_ex.c        
        src/stm32f4xx_ll_dac.c
        src/stm32f4xx_hal_dma.c      
        src/stm32f4xx_hal_irda.c           
        src/stm32f4xx_hal_sai.c           
        src/stm32f4xx_ll_dma2d.c
        src/stm32f4xx_hal_dma_ex.c   
        src/stm32f4xx_hal_iwdg.c           
        src/stm32f4xx_hal_sai_ex.c        
        src/stm32f4xx_ll_dma.c
        src/stm32f4xx_hal_dsi.c      
        src/stm32f4xx_hal_lptim.c          
        src/stm32f4xx_hal_sd.c            
        src/stm32f4xx_ll_exti.c
        src/Legacy/stm32f4xx_hal_can.c
)






