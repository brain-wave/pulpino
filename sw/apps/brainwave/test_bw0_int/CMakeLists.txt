set(CONV_SOURCES convolution.c conv_kernels.c)
add_application(test_bw0_int "${CONV_SOURCES}" FLAGS "-DPROFILE")
