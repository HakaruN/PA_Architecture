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

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/ArithmaticUnit.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};
static int ng3[] = {2, 0};
static int ng4[] = {3, 0};



static void Always_15_0(char *t0)
{
    char t14[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    int t13;

LAB0:    t1 = (t0 + 3640U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(15, ng0);
    t2 = (t0 + 3960);
    *((int *)t2) = 1;
    t3 = (t0 + 3672);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(16, ng0);

LAB5:    xsi_set_current_line(18, ng0);
    t4 = (t0 + 1368U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(19, ng0);

LAB9:    xsi_set_current_line(20, ng0);
    t11 = (t0 + 1208U);
    t12 = *((char **)t11);
    t11 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t11, t12, 0, 0, 1, 0LL);
    xsi_set_current_line(21, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 5, 0LL);
    xsi_set_current_line(22, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);

LAB10:    t2 = ((char*)((ng1)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t13 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng2)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t13 == 1)
        goto LAB13;

LAB14:    t2 = ((char*)((ng3)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t13 == 1)
        goto LAB15;

LAB16:    t2 = ((char*)((ng4)));
    t13 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t13 == 1)
        goto LAB17;

LAB18:
LAB19:    goto LAB8;

LAB11:    xsi_set_current_line(23, ng0);

LAB20:    xsi_set_current_line(23, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(23, ng0);
    t2 = ((char*)((ng1)));
    t4 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 16, 0LL);
    goto LAB19;

LAB13:    xsi_set_current_line(24, ng0);

LAB21:    xsi_set_current_line(24, ng0);
    t4 = (t0 + 1848U);
    t5 = *((char **)t4);
    t4 = (t0 + 2008U);
    t11 = *((char **)t4);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_add(t14, 16, t5, 16, t11, 16);
    t4 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t4, t14, 0, 0, 16, 0LL);
    goto LAB19;

LAB15:    xsi_set_current_line(25, ng0);

LAB22:    xsi_set_current_line(25, ng0);
    t4 = (t0 + 1848U);
    t5 = *((char **)t4);
    t4 = (t0 + 2008U);
    t11 = *((char **)t4);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_minus(t14, 16, t5, 16, t11, 16);
    t4 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t4, t14, 0, 0, 16, 0LL);
    goto LAB19;

LAB17:    xsi_set_current_line(26, ng0);

LAB23:    xsi_set_current_line(26, ng0);
    t4 = (t0 + 1848U);
    t5 = *((char **)t4);
    t4 = (t0 + 2008U);
    t11 = *((char **)t4);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_multiply(t14, 16, t5, 16, t11, 16);
    t4 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t4, t14, 0, 0, 16, 0LL);
    goto LAB19;

}


extern void work_m_08162717688828823856_4049314868_init()
{
	static char *pe[] = {(void *)Always_15_0};
	xsi_register_didat("work_m_08162717688828823856_4049314868", "isim/coreTest_isim_beh.exe.sim/work/m_08162717688828823856_4049314868.didat");
	xsi_register_executes(pe);
}
