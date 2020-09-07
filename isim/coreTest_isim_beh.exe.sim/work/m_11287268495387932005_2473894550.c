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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/RegisterFrameUnit.v";
static int ng1[] = {0, 0};
static int ng2[] = {12, 0};
static int ng3[] = {1, 0};
static int ng4[] = {13, 0};
static int ng5[] = {14, 0};
static int ng6[] = {15, 0};



static void Always_12_0(char *t0)
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
    char *t15;

LAB0:    t1 = (t0 + 3000U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(12, ng0);
    t2 = (t0 + 3320);
    *((int *)t2) = 1;
    t3 = (t0 + 3032);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(13, ng0);

LAB5:    xsi_set_current_line(14, ng0);
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
LAB8:    xsi_set_current_line(17, ng0);
    t2 = (t0 + 1208U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB9;

LAB10:
LAB11:    goto LAB2;

LAB6:    xsi_set_current_line(15, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 6, 0LL);
    goto LAB8;

LAB9:    xsi_set_current_line(18, ng0);

LAB12:    xsi_set_current_line(19, ng0);
    t4 = (t0 + 1528U);
    t5 = *((char **)t4);

LAB13:    t4 = ((char*)((ng2)));
    t13 = xsi_vlog_unsigned_case_compare(t5, 7, t4, 32);
    if (t13 == 1)
        goto LAB14;

LAB15:    t2 = ((char*)((ng4)));
    t13 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t13 == 1)
        goto LAB16;

LAB17:    t2 = ((char*)((ng5)));
    t13 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t13 == 1)
        goto LAB18;

LAB19:    t2 = ((char*)((ng6)));
    t13 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t13 == 1)
        goto LAB20;

LAB21:
LAB22:    goto LAB11;

LAB14:    xsi_set_current_line(20, ng0);

LAB23:    xsi_set_current_line(20, ng0);
    t11 = (t0 + 1688U);
    t12 = *((char **)t11);
    t11 = ((char*)((ng3)));
    memset(t14, 0, 8);
    xsi_vlog_unsigned_add(t14, 32, t12, 6, t11, 32);
    t15 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t15, t14, 0, 0, 6, 0LL);
    goto LAB22;

LAB16:    xsi_set_current_line(21, ng0);

LAB24:    xsi_set_current_line(21, ng0);
    t3 = (t0 + 1688U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng3)));
    memset(t14, 0, 8);
    xsi_vlog_unsigned_minus(t14, 32, t4, 6, t3, 32);
    t11 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t11, t14, 0, 0, 6, 0LL);
    goto LAB22;

LAB18:    xsi_set_current_line(22, ng0);

LAB25:    xsi_set_current_line(22, ng0);
    t3 = (t0 + 1688U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng3)));
    memset(t14, 0, 8);
    xsi_vlog_unsigned_add(t14, 32, t4, 6, t3, 32);
    t11 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t11, t14, 0, 0, 6, 0LL);
    goto LAB22;

LAB20:    xsi_set_current_line(23, ng0);

LAB26:    xsi_set_current_line(23, ng0);
    t3 = (t0 + 1688U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng3)));
    memset(t14, 0, 8);
    xsi_vlog_unsigned_minus(t14, 32, t4, 6, t3, 32);
    t11 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t11, t14, 0, 0, 6, 0LL);
    goto LAB22;

}


extern void work_m_11287268495387932005_2473894550_init()
{
	static char *pe[] = {(void *)Always_12_0};
	xsi_register_didat("work_m_11287268495387932005_2473894550", "isim/coreTest_isim_beh.exe.sim/work/m_11287268495387932005_2473894550.didat");
	xsi_register_executes(pe);
}
