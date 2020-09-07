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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/RegisterFile.v";
static int ng1[] = {0, 0};
static int ng2[] = {2, 0};
static int ng3[] = {1, 0};



static void Always_27_0(char *t0)
{
    char t13[8];
    char t14[8];
    char t19[8];
    char t21[8];
    char t22[8];
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
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t20;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    unsigned int t33;
    int t34;
    char *t35;
    unsigned int t36;
    int t37;
    int t38;
    unsigned int t39;
    unsigned int t40;
    int t41;
    int t42;

LAB0:    t1 = (t0 + 5992U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(27, ng0);
    t2 = (t0 + 6312);
    *((int *)t2) = 1;
    t3 = (t0 + 6024);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(28, ng0);

LAB5:    xsi_set_current_line(29, ng0);
    t4 = (t0 + 1480U);
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
LAB8:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 2760U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB16;

LAB17:    xsi_set_current_line(45, ng0);
    t2 = (t0 + 3400U);
    t3 = *((char **)t2);
    memcpy(t13, t3, 8);
    t2 = (t0 + 4280);
    xsi_vlogvar_wait_assign_value(t2, t13, 0, 0, 16, 0LL);

LAB18:    xsi_set_current_line(47, ng0);
    t2 = (t0 + 3080U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB19;

LAB20:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 3720U);
    t3 = *((char **)t2);
    t2 = (t0 + 4600);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 16, 0LL);

LAB21:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 2920U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB22;

LAB23:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 3560U);
    t3 = *((char **)t2);
    memcpy(t13, t3, 8);
    t2 = (t0 + 4440);
    xsi_vlogvar_wait_assign_value(t2, t13, 0, 0, 16, 0LL);

LAB24:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 3240U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB25;

LAB26:    xsi_set_current_line(61, ng0);
    t2 = (t0 + 3880U);
    t3 = *((char **)t2);
    t2 = (t0 + 4760);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 16, 0LL);

LAB27:    xsi_set_current_line(65, ng0);
    t2 = (t0 + 1800U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB28;

LAB29:
LAB30:    xsi_set_current_line(70, ng0);
    t2 = (t0 + 1960U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB34;

LAB35:
LAB36:    goto LAB2;

LAB6:    xsi_set_current_line(30, ng0);

LAB9:    xsi_set_current_line(32, ng0);
    xsi_set_current_line(32, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 5080);
    xsi_vlogvar_assign_value(t12, t11, 0, 0, 32);

LAB10:    t2 = (t0 + 5080);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 472);
    t11 = *((char **)t5);
    t5 = (t0 + 608);
    t12 = *((char **)t5);
    memset(t13, 0, 8);
    xsi_vlog_signed_multiply(t13, 32, t11, 32, t12, 32);
    memset(t14, 0, 8);
    xsi_vlog_signed_less(t14, 32, t4, 32, t13, 32);
    t5 = (t14 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t14);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB11;

LAB12:    goto LAB8;

LAB11:    xsi_set_current_line(33, ng0);

LAB13:    xsi_set_current_line(35, ng0);
    t15 = (t0 + 5080);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = ((char*)((ng2)));
    memset(t19, 0, 8);
    xsi_vlog_signed_add(t19, 32, t17, 32, t18, 32);
    t20 = (t0 + 4920);
    t23 = (t0 + 4920);
    t24 = (t23 + 72U);
    t25 = *((char **)t24);
    t26 = (t0 + 4920);
    t27 = (t26 + 64U);
    t28 = *((char **)t27);
    t29 = (t0 + 5080);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    xsi_vlog_generic_convert_array_indices(t21, t22, t25, t28, 2, 1, t31, 32, 1);
    t32 = (t21 + 4);
    t33 = *((unsigned int *)t32);
    t34 = (!(t33));
    t35 = (t22 + 4);
    t36 = *((unsigned int *)t35);
    t37 = (!(t36));
    t38 = (t34 && t37);
    if (t38 == 1)
        goto LAB14;

LAB15:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 5080);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng3)));
    memset(t13, 0, 8);
    xsi_vlog_signed_add(t13, 32, t4, 32, t5, 32);
    t11 = (t0 + 5080);
    xsi_vlogvar_assign_value(t11, t13, 0, 0, 32);
    goto LAB10;

LAB14:    t39 = *((unsigned int *)t21);
    t40 = *((unsigned int *)t22);
    t41 = (t39 - t40);
    t42 = (t41 + 1);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, *((unsigned int *)t22), t42, 0LL);
    goto LAB15;

LAB16:    xsi_set_current_line(43, ng0);
    t4 = (t0 + 4920);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 4920);
    t15 = (t12 + 72U);
    t16 = *((char **)t15);
    t17 = (t0 + 4920);
    t18 = (t17 + 64U);
    t20 = *((char **)t18);
    t23 = (t0 + 1640U);
    t24 = *((char **)t23);
    t23 = (t0 + 472);
    t25 = *((char **)t23);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_multiply(t14, 32, t24, 6, t25, 32);
    t23 = (t0 + 3400U);
    t26 = *((char **)t23);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_add(t19, 32, t14, 32, t26, 5);
    xsi_vlog_generic_get_array_select_value(t13, 16, t11, t16, t20, 2, 1, t19, 32, 2);
    t23 = (t0 + 4280);
    xsi_vlogvar_wait_assign_value(t23, t13, 0, 0, 16, 0LL);
    goto LAB18;

LAB19:    xsi_set_current_line(48, ng0);
    t4 = (t0 + 4920);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 4920);
    t15 = (t12 + 72U);
    t16 = *((char **)t15);
    t17 = (t0 + 4920);
    t18 = (t17 + 64U);
    t20 = *((char **)t18);
    t23 = (t0 + 1640U);
    t24 = *((char **)t23);
    t23 = (t0 + 472);
    t25 = *((char **)t23);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_multiply(t14, 32, t24, 6, t25, 32);
    t23 = (t0 + 3720U);
    t26 = *((char **)t23);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_add(t19, 32, t14, 32, t26, 16);
    xsi_vlog_generic_get_array_select_value(t13, 16, t11, t16, t20, 2, 1, t19, 32, 2);
    t23 = (t0 + 4600);
    xsi_vlogvar_wait_assign_value(t23, t13, 0, 0, 16, 0LL);
    goto LAB21;

LAB22:    xsi_set_current_line(54, ng0);
    t4 = (t0 + 4920);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 4920);
    t15 = (t12 + 72U);
    t16 = *((char **)t15);
    t17 = (t0 + 4920);
    t18 = (t17 + 64U);
    t20 = *((char **)t18);
    t23 = (t0 + 1640U);
    t24 = *((char **)t23);
    t23 = (t0 + 472);
    t25 = *((char **)t23);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_multiply(t14, 32, t24, 6, t25, 32);
    t23 = (t0 + 3560U);
    t26 = *((char **)t23);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_add(t19, 32, t14, 32, t26, 5);
    xsi_vlog_generic_get_array_select_value(t13, 16, t11, t16, t20, 2, 1, t19, 32, 2);
    t23 = (t0 + 4440);
    xsi_vlogvar_wait_assign_value(t23, t13, 0, 0, 16, 0LL);
    goto LAB24;

LAB25:    xsi_set_current_line(59, ng0);
    t4 = (t0 + 4920);
    t5 = (t4 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 4920);
    t15 = (t12 + 72U);
    t16 = *((char **)t15);
    t17 = (t0 + 4920);
    t18 = (t17 + 64U);
    t20 = *((char **)t18);
    t23 = (t0 + 1640U);
    t24 = *((char **)t23);
    t23 = (t0 + 472);
    t25 = *((char **)t23);
    memset(t14, 0, 8);
    xsi_vlog_unsigned_multiply(t14, 32, t24, 6, t25, 32);
    t23 = (t0 + 3880U);
    t26 = *((char **)t23);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_add(t19, 32, t14, 32, t26, 16);
    xsi_vlog_generic_get_array_select_value(t13, 16, t11, t16, t20, 2, 1, t19, 32, 2);
    t23 = (t0 + 4760);
    xsi_vlogvar_wait_assign_value(t23, t13, 0, 0, 16, 0LL);
    goto LAB27;

LAB28:    xsi_set_current_line(66, ng0);

LAB31:    xsi_set_current_line(67, ng0);
    t4 = (t0 + 2440U);
    t5 = *((char **)t4);
    t4 = (t0 + 4920);
    t11 = (t0 + 4920);
    t12 = (t11 + 72U);
    t15 = *((char **)t12);
    t16 = (t0 + 4920);
    t17 = (t16 + 64U);
    t18 = *((char **)t17);
    t20 = (t0 + 1640U);
    t23 = *((char **)t20);
    t20 = (t0 + 472);
    t24 = *((char **)t20);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_multiply(t19, 32, t23, 6, t24, 32);
    t20 = (t0 + 2120U);
    t25 = *((char **)t20);
    memset(t21, 0, 8);
    xsi_vlog_unsigned_add(t21, 32, t19, 32, t25, 5);
    xsi_vlog_generic_convert_array_indices(t13, t14, t15, t18, 2, 1, t21, 32, 2);
    t20 = (t13 + 4);
    t33 = *((unsigned int *)t20);
    t34 = (!(t33));
    t26 = (t14 + 4);
    t36 = *((unsigned int *)t26);
    t37 = (!(t36));
    t38 = (t34 && t37);
    if (t38 == 1)
        goto LAB32;

LAB33:    goto LAB30;

LAB32:    t39 = *((unsigned int *)t13);
    t40 = *((unsigned int *)t14);
    t41 = (t39 - t40);
    t42 = (t41 + 1);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, *((unsigned int *)t14), t42, 0LL);
    goto LAB33;

LAB34:    xsi_set_current_line(71, ng0);

LAB37:    xsi_set_current_line(72, ng0);
    t4 = (t0 + 2600U);
    t5 = *((char **)t4);
    t4 = (t0 + 4920);
    t11 = (t0 + 4920);
    t12 = (t11 + 72U);
    t15 = *((char **)t12);
    t16 = (t0 + 4920);
    t17 = (t16 + 64U);
    t18 = *((char **)t17);
    t20 = (t0 + 1640U);
    t23 = *((char **)t20);
    t20 = (t0 + 472);
    t24 = *((char **)t20);
    memset(t19, 0, 8);
    xsi_vlog_unsigned_multiply(t19, 32, t23, 6, t24, 32);
    t20 = (t0 + 2280U);
    t25 = *((char **)t20);
    memset(t21, 0, 8);
    xsi_vlog_unsigned_add(t21, 32, t19, 32, t25, 5);
    xsi_vlog_generic_convert_array_indices(t13, t14, t15, t18, 2, 1, t21, 32, 2);
    t20 = (t13 + 4);
    t33 = *((unsigned int *)t20);
    t34 = (!(t33));
    t26 = (t14 + 4);
    t36 = *((unsigned int *)t26);
    t37 = (!(t36));
    t38 = (t34 && t37);
    if (t38 == 1)
        goto LAB38;

LAB39:    goto LAB36;

LAB38:    t39 = *((unsigned int *)t13);
    t40 = *((unsigned int *)t14);
    t41 = (t39 - t40);
    t42 = (t41 + 1);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, *((unsigned int *)t14), t42, 0LL);
    goto LAB39;

}


extern void work_m_15582625525611041097_3674772129_init()
{
	static char *pe[] = {(void *)Always_27_0};
	xsi_register_didat("work_m_15582625525611041097_3674772129", "isim/coreTest_isim_beh.exe.sim/work/m_15582625525611041097_3674772129.didat");
	xsi_register_executes(pe);
}
