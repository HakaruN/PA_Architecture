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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/BranchUnit.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};
static int ng3[] = {8, 0};
static int ng4[] = {5, 0};
static int ng5[] = {9, 0};
static int ng6[] = {10, 0};
static int ng7[] = {11, 0};



static void Always_13_0(char *t0)
{
    char t13[8];
    char t26[8];
    char t29[8];
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
    int t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    char *t27;
    char *t28;

LAB0:    t1 = (t0 + 3320U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(13, ng0);
    t2 = (t0 + 3640);
    *((int *)t2) = 1;
    t3 = (t0 + 3352);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(14, ng0);

LAB5:    xsi_set_current_line(16, ng0);
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

LAB7:    xsi_set_current_line(19, ng0);
    t2 = (t0 + 2008U);
    t3 = *((char **)t2);
    t2 = ((char*)((ng2)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_add(t13, 32, t3, 16, t2, 32);
    t4 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t4, t13, 0, 0, 16, 0LL);

LAB8:    xsi_set_current_line(21, ng0);
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

LAB6:    xsi_set_current_line(17, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 16, 0LL);
    goto LAB8;

LAB9:    xsi_set_current_line(22, ng0);

LAB12:    xsi_set_current_line(23, ng0);
    t4 = (t0 + 1528U);
    t5 = *((char **)t4);

LAB13:    t4 = ((char*)((ng3)));
    t14 = xsi_vlog_unsigned_case_compare(t5, 7, t4, 32);
    if (t14 == 1)
        goto LAB14;

LAB15:    t2 = ((char*)((ng5)));
    t14 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t14 == 1)
        goto LAB16;

LAB17:    t2 = ((char*)((ng6)));
    t14 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t14 == 1)
        goto LAB18;

LAB19:    t2 = ((char*)((ng7)));
    t14 = xsi_vlog_unsigned_case_compare(t5, 7, t2, 32);
    if (t14 == 1)
        goto LAB20;

LAB21:
LAB22:    goto LAB11;

LAB14:    xsi_set_current_line(25, ng0);

LAB23:    xsi_set_current_line(25, ng0);
    t11 = (t0 + 1848U);
    t12 = *((char **)t11);
    t11 = ((char*)((ng1)));
    memset(t13, 0, 8);
    t15 = (t12 + 4);
    if (*((unsigned int *)t15) != 0)
        goto LAB25;

LAB24:    t16 = (t11 + 4);
    if (*((unsigned int *)t16) != 0)
        goto LAB25;

LAB28:    if (*((unsigned int *)t12) > *((unsigned int *)t11))
        goto LAB26;

LAB27:    t18 = (t13 + 4);
    t19 = *((unsigned int *)t18);
    t20 = (~(t19));
    t21 = *((unsigned int *)t13);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB29;

LAB30:
LAB31:    goto LAB22;

LAB16:    xsi_set_current_line(26, ng0);

LAB33:    xsi_set_current_line(26, ng0);
    t3 = (t0 + 1848U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng1)));
    memset(t13, 0, 8);
    t11 = (t4 + 4);
    if (*((unsigned int *)t11) != 0)
        goto LAB35;

LAB34:    t12 = (t3 + 4);
    if (*((unsigned int *)t12) != 0)
        goto LAB35;

LAB38:    if (*((unsigned int *)t4) > *((unsigned int *)t3))
        goto LAB36;

LAB37:    t16 = (t13 + 4);
    t6 = *((unsigned int *)t16);
    t7 = (~(t6));
    t8 = *((unsigned int *)t13);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB39;

LAB40:
LAB41:    goto LAB22;

LAB18:    xsi_set_current_line(27, ng0);

LAB43:    xsi_set_current_line(27, ng0);
    t3 = (t0 + 2008U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng4)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_minus(t13, 32, t4, 16, t3, 32);
    t11 = (t0 + 1688U);
    t12 = *((char **)t11);
    memset(t26, 0, 8);
    xsi_vlog_unsigned_minus(t26, 32, t13, 32, t12, 16);
    t11 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t11, t26, 0, 0, 16, 0LL);
    goto LAB22;

LAB20:    xsi_set_current_line(28, ng0);

LAB44:    xsi_set_current_line(28, ng0);
    t3 = (t0 + 2008U);
    t4 = *((char **)t3);
    t3 = ((char*)((ng4)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_minus(t13, 32, t4, 16, t3, 32);
    t11 = (t0 + 1688U);
    t12 = *((char **)t11);
    memset(t26, 0, 8);
    xsi_vlog_unsigned_add(t26, 32, t13, 32, t12, 16);
    t11 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t11, t26, 0, 0, 16, 0LL);
    goto LAB22;

LAB25:    t17 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t17) = 1;
    goto LAB27;

LAB26:    *((unsigned int *)t13) = 1;
    goto LAB27;

LAB29:    xsi_set_current_line(25, ng0);

LAB32:    xsi_set_current_line(25, ng0);
    t24 = (t0 + 2008U);
    t25 = *((char **)t24);
    t24 = ((char*)((ng4)));
    memset(t26, 0, 8);
    xsi_vlog_unsigned_minus(t26, 32, t25, 16, t24, 32);
    t27 = (t0 + 1688U);
    t28 = *((char **)t27);
    memset(t29, 0, 8);
    xsi_vlog_unsigned_minus(t29, 32, t26, 32, t28, 16);
    t27 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t27, t29, 0, 0, 16, 0LL);
    goto LAB31;

LAB35:    t15 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t15) = 1;
    goto LAB37;

LAB36:    *((unsigned int *)t13) = 1;
    goto LAB37;

LAB39:    xsi_set_current_line(26, ng0);

LAB42:    xsi_set_current_line(26, ng0);
    t17 = (t0 + 2008U);
    t18 = *((char **)t17);
    t17 = ((char*)((ng4)));
    memset(t26, 0, 8);
    xsi_vlog_unsigned_minus(t26, 32, t18, 16, t17, 32);
    t24 = (t0 + 1688U);
    t25 = *((char **)t24);
    memset(t29, 0, 8);
    xsi_vlog_unsigned_add(t29, 32, t26, 32, t25, 16);
    t24 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t24, t29, 0, 0, 16, 0LL);
    goto LAB41;

}


extern void work_m_08382582048092007068_3995010707_init()
{
	static char *pe[] = {(void *)Always_13_0};
	xsi_register_didat("work_m_08382582048092007068_3995010707", "isim/coreTest_isim_beh.exe.sim/work/m_08382582048092007068_3995010707.didat");
	xsi_register_executes(pe);
}
