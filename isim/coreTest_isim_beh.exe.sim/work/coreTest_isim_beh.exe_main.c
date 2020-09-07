/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_12814034522328656353_1307194410_init();
    work_m_05968071357905805551_1334150395_init();
    work_m_16152463970888391459_1158921438_init();
    work_m_15582625525611041097_3674772129_init();
    work_m_16085518034477302216_0130119643_init();
    work_m_10720330352328477982_0808562939_init();
    work_m_08162717688828823856_4049314868_init();
    work_m_08382582048092007068_3995010707_init();
    work_m_11287268495387932005_2473894550_init();
    work_m_11878413109932374157_1926144903_init();
    work_m_05032244322659917459_3192838712_init();
    work_m_16541823861846354283_2073120511_init();


    xsi_register_tops("work_m_05032244322659917459_3192838712");
    xsi_register_tops("work_m_16541823861846354283_2073120511");


    return xsi_run_simulation(argc, argv);

}
