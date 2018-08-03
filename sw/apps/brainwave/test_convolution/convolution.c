// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

#include "utils.h" // get_core_id()
#include "bar.h" // sync_barrier()
#include "string_lib.h" // printf()
#include "convolution.h"

// Large data arrays
static Pixel __attribute__ ((section(".heapsram"))) Out[IMG_DIM];
static Pixel __attribute__ ((section(".heapsram"))) In[IMG_DIM];
static Filtc __attribute__ ((section(".heapsram"))) Kernel[FILT_DIM];


// load kernel
static void InitKernel(Filtc *Kernel, int size)
{
    for (int i = 0; i < size*size; i++) {
        Kernel[i] = Filter_Kern[i];
    }
}

// load input img
static void InitData(Pixel *Img, int size)
{
    for (int i = 0; i < size; i++) {
        Img[i] = In_Img[i];
    }
}

// load initialize out to 0
static void InitZero(Pixel *Img, int size)
{
    for (int i = 0; i < size; i++) {
        Img[i] = 0;
    }
}

// check result
static int checkresult(Pixel *Out, Pixel *OutGold, int N)
{
    int err = 0;
    for (int i = 0; i < N; i++) {
        if (Out[i] != OutGold[i]) {
            err++;
        }
    }
    return err;
}

// kernel computation
static void check_Conv5x5_Scalar(int *errors) 
{
    // start benchmark
    int err = 0;
    Filtc Kernel5x5_Scalar[FILT_DIM];
    Pixel In[IMG_DIM];

    printf("2D Convolution WINDOW=%d, DATA_WIDTH=%d\n",FILT_WIN,DATA_WIDTH);
    InitKernel(Kernel5x5_Scalar,FILT_WIN);
    InitData(In, IMG_DIM);
    InitZero(Out, IMG_DIM);
    Conv5x5_Scalar(In, Out, IMG_ROW, IMG_COL, Kernel5x5_Scalar);

    *errors = checkresult(Out, Gold_Out_Img, IMG_DIM);
}

int main()
{
    int errors = 0;
    if(get_core_id() == 0){
        check_Conv5x5_Scalar(&errors);
    }
    synch_barrier();
    
    printf("nr. of errors: %d\n", errors);
    return 0;
}
