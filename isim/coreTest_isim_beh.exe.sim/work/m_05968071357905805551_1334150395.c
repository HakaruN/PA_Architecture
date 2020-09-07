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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/Parser.v";



static void Always_20_0(char *t0)
{
    char t11[16];
    char t12[8];
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
    unsigned int t13;
    char *t14;

LAB0:    t1 = (t0 + 4920U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(20, ng0);
    t2 = (t0 + 5488);
    *((int *)t2) = 1;
    t3 = (t0 + 4952);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(21, ng0);

LAB5:    xsi_set_current_line(22, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(23, ng0);
    t2 = (t0 + 1208U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(24, ng0);

LAB9:    xsi_set_current_line(25, ng0);
    t4 = (t0 + 1368U);
    t5 = *((char **)t4);
    xsi_vlog_get_part_select_value(t11, 59, t5, 58, 0);
    t4 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t4, t11, 0, 0, 59, 0LL);
    xsi_set_current_line(26, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    memset(t12, 0, 8);
    t2 = (t12 + 4);
    t4 = (t3 + 8);
    t5 = (t3 + 12);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 27);
    t8 = (t7 & 1);
    *((unsigned int *)t12) = t8;
    t9 = *((unsigned int *)t5);
    t10 = (t9 >> 27);
    t13 = (t10 & 1);
    *((unsigned int *)t2) = t13;
    t14 = (t0 + 3688);
    xsi_vlogvar_wait_assign_value(t14, t12, 0, 0, 1, 0LL);
    goto LAB8;

}

static void Always_30_1(char *t0)
{
    char t15[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    unsigned int t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;

LAB0:    t1 = (t0 + 5168U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(30, ng0);
    t2 = (t0 + 5504);
    *((int *)t2) = 1;
    t3 = (t0 + 5200);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(31, ng0);

LAB5:    xsi_set_current_line(32, ng0);
    t4 = (t0 + 3848);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t0 + 3368);
    xsi_vlogvar_wait_assign_value(t7, t6, 0, 0, 1, 0LL);
    xsi_set_current_line(33, ng0);
    t2 = (t0 + 3848);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 3528);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(34, ng0);
    t2 = (t0 + 3848);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 4);
    t8 = *((unsigned int *)t5);
    t9 = (~(t8));
    t10 = *((unsigned int *)t4);
    t11 = (t10 & t9);
    t12 = (t11 != 0);
    if (t12 > 0)
        goto LAB6;

LAB7:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(35, ng0);

LAB9:    xsi_set_current_line(37, ng0);
    t6 = (t0 + 3688);
    t7 = (t6 + 56U);
    t13 = *((char **)t7);
    t14 = (t0 + 2088);
    xsi_vlogvar_wait_assign_value(t14, t13, 0, 0, 1, 0LL);
    xsi_set_current_line(38, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 26);
    t10 = (t9 & 1);
    *((unsigned int *)t15) = t10;
    t11 = *((unsigned int *)t7);
    t12 = (t11 >> 26);
    t16 = (t12 & 1);
    *((unsigned int *)t5) = t16;
    t13 = (t0 + 1768);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(39, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 19);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 19);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 127U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 127U);
    t13 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 7, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 14);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 14);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 31U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 31U);
    t13 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 5, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = (t0 + 3688);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 4);
    t8 = *((unsigned int *)t5);
    t9 = (~(t8));
    t10 = *((unsigned int *)t4);
    t11 = (t10 & t9);
    t12 = (t11 != 0);
    if (t12 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(53, ng0);

LAB14:    xsi_set_current_line(55, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 9);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 9);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 31U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 31U);
    t13 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 16, 0LL);
    xsi_set_current_line(56, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 8);
    t10 = (t9 & 1);
    *((unsigned int *)t15) = t10;
    t11 = *((unsigned int *)t7);
    t12 = (t11 >> 8);
    t16 = (t12 & 1);
    *((unsigned int *)t5) = t16;
    t13 = (t0 + 2248);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(57, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 7);
    t10 = (t9 & 1);
    *((unsigned int *)t15) = t10;
    t11 = *((unsigned int *)t7);
    t12 = (t11 >> 7);
    t16 = (t12 & 1);
    *((unsigned int *)t5) = t16;
    t13 = (t0 + 1928);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 8);
    t7 = (t4 + 12);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 0);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 0);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 127U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 127U);
    t13 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t13, t15, 0, 0, 7, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 27);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 27);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 31U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 31U);
    t7 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 5, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 11);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 11);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 65535U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 65535U);
    t7 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 16, 0LL);

LAB12:    goto LAB8;

LAB10:    xsi_set_current_line(42, ng0);

LAB13:    xsi_set_current_line(44, ng0);
    t6 = (t0 + 4008);
    t7 = (t6 + 56U);
    t13 = *((char **)t7);
    memset(t15, 0, 8);
    t14 = (t15 + 4);
    t17 = (t13 + 4);
    t16 = *((unsigned int *)t13);
    t18 = (t16 >> 30);
    *((unsigned int *)t15) = t18;
    t19 = *((unsigned int *)t17);
    t20 = (t19 >> 30);
    *((unsigned int *)t14) = t20;
    t21 = (t13 + 8);
    t22 = (t13 + 12);
    t23 = *((unsigned int *)t21);
    t24 = (t23 << 2);
    t25 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t25 | t24);
    t26 = *((unsigned int *)t22);
    t27 = (t26 << 2);
    t28 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t28 | t27);
    t29 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t29 & 65535U);
    t30 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t30 & 65535U);
    t31 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t31, t15, 0, 0, 16, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 29);
    t10 = (t9 & 1);
    *((unsigned int *)t15) = t10;
    t11 = *((unsigned int *)t6);
    t12 = (t11 >> 29);
    t16 = (t12 & 1);
    *((unsigned int *)t5) = t16;
    t7 = (t0 + 2248);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 28);
    t10 = (t9 & 1);
    *((unsigned int *)t15) = t10;
    t11 = *((unsigned int *)t6);
    t12 = (t11 >> 28);
    t16 = (t12 & 1);
    *((unsigned int *)t5) = t16;
    t7 = (t0 + 1928);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(48, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 21);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 21);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 127U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 127U);
    t7 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 7, 0LL);
    xsi_set_current_line(49, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 16);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 16);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 31U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 31U);
    t7 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 5, 0LL);
    xsi_set_current_line(50, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t15, 0, 8);
    t5 = (t15 + 4);
    t6 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 0);
    *((unsigned int *)t15) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 0);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t12 & 65535U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 65535U);
    t7 = (t0 + 3208);
    xsi_vlogvar_wait_assign_value(t7, t15, 0, 0, 16, 0LL);
    goto LAB12;

}


extern void work_m_05968071357905805551_1334150395_init()
{
	static char *pe[] = {(void *)Always_20_0,(void *)Always_30_1};
	xsi_register_didat("work_m_05968071357905805551_1334150395", "isim/coreTest_isim_beh.exe.sim/work/m_05968071357905805551_1334150395.didat");
	xsi_register_executes(pe);
}
