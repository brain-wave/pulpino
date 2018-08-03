set(CONV_SOURCES convolution.c conv_kernels.c)
add_application(test_convolution "${CONV_SOURCES}" FLAGS "-DPROFILE")
