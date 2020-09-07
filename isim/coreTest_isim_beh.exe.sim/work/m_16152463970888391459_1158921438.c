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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/Decode.v";
static int ng1[] = {8, 0};
static int ng2[] = {3, 0};
static int ng3[] = {1, 0};
static int ng4[] = {0, 0};
static int ng5[] = {9, 0};
static int ng6[] = {10, 0};
static int ng7[] = {11, 0};
static int ng8[] = {2, 0};
static int ng9[] = {4, 0};
static int ng10[] = {5, 0};



static void Always_23_0(char *t0)
{
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
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    int t18;
    char *t19;
    char *t20;

LAB0:    t1 = (t0 + 4576U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(23, ng0);
    t2 = (t0 + 4896);
    *((int *)t2) = 1;
    t3 = (t0 + 4608);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(24, ng0);

LAB5:    xsi_set_current_line(25, ng0);
    t4 = (t0 + 1344U);
    t5 = *((char **)t4);
    t4 = (t0 + 3664);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(27, ng0);
    t2 = (t0 + 1344U);
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

LAB6:    xsi_set_current_line(28, ng0);

LAB9:    xsi_set_current_line(29, ng0);
    t4 = (t0 + 1824U);
    t5 = *((char **)t4);
    t4 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t4, t5, 0, 0, 7, 0LL);
    xsi_set_current_line(30, ng0);
    t2 = (t0 + 1984U);
    t3 = *((char **)t2);
    t2 = (t0 + 2864);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 5, 0LL);
    xsi_set_current_line(31, ng0);
    t2 = (t0 + 2144U);
    t3 = *((char **)t2);
    t2 = (t0 + 3024);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 16, 0LL);
    xsi_set_current_line(33, ng0);
    t2 = (t0 + 1504U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(53, ng0);

LAB46:    xsi_set_current_line(54, ng0);
    t2 = (t0 + 1664U);
    t4 = *((char **)t2);
    t2 = (t4 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB47;

LAB48:    xsi_set_current_line(69, ng0);

LAB71:    xsi_set_current_line(70, ng0);
    t2 = (t0 + 1824U);
    t4 = *((char **)t2);

LAB72:    t2 = ((char*)((ng4)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB73;

LAB74:    t2 = ((char*)((ng3)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB75;

LAB76:    t2 = ((char*)((ng8)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB77;

LAB78:    t2 = ((char*)((ng2)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB79;

LAB80:    t2 = ((char*)((ng9)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB81;

LAB82:    t2 = ((char*)((ng10)));
    t18 = xsi_vlog_unsigned_case_compare(t4, 7, t2, 32);
    if (t18 == 1)
        goto LAB83;

LAB84:
LAB85:
LAB49:
LAB12:    goto LAB8;

LAB10:    xsi_set_current_line(34, ng0);
    t4 = (t0 + 1664U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t11 = *((unsigned int *)t4);
    t12 = (~(t11));
    t13 = *((unsigned int *)t5);
    t14 = (t13 & t12);
    t15 = (t14 != 0);
    if (t15 > 0)
        goto LAB13;

LAB14:    xsi_set_current_line(44, ng0);

LAB31:    xsi_set_current_line(45, ng0);
    t2 = (t0 + 1824U);
    t3 = *((char **)t2);

LAB32:    t2 = ((char*)((ng1)));
    t18 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t18 == 1)
        goto LAB33;

LAB34:    t2 = ((char*)((ng5)));
    t18 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t18 == 1)
        goto LAB35;

LAB36:    t2 = ((char*)((ng6)));
    t18 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t18 == 1)
        goto LAB37;

LAB38:    t2 = ((char*)((ng7)));
    t18 = xsi_vlog_unsigned_case_compare(t3, 7, t2, 32);
    if (t18 == 1)
        goto LAB39;

LAB40:
LAB41:
LAB15:    goto LAB12;

LAB13:    xsi_set_current_line(35, ng0);

LAB16:    xsi_set_current_line(36, ng0);
    t16 = (t0 + 1824U);
    t17 = *((char **)t16);

LAB17:    t16 = ((char*)((ng1)));
    t18 = xsi_vlog_unsigned_case_compare(t17, 7, t16, 32);
    if (t18 == 1)
        goto LAB18;

LAB19:    t2 = ((char*)((ng5)));
    t18 = xsi_vlog_unsigned_case_compare(t17, 7, t2, 32);
    if (t18 == 1)
        goto LAB20;

LAB21:    t2 = ((char*)((ng6)));
    t18 = xsi_vlog_unsigned_case_compare(t17, 7, t2, 32);
    if (t18 == 1)
        goto LAB22;

LAB23:    t2 = ((char*)((ng7)));
    t18 = xsi_vlog_unsigned_case_compare(t17, 7, t2, 32);
    if (t18 == 1)
        goto LAB24;

LAB25:
LAB26:    goto LAB15;

LAB18:    xsi_set_current_line(37, ng0);

LAB27:    xsi_set_current_line(37, ng0);
    t19 = ((char*)((ng2)));
    t20 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 2, 0LL);
    xsi_set_current_line(37, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(37, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(37, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB26;

LAB20:    xsi_set_current_line(38, ng0);

LAB28:    xsi_set_current_line(38, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t4, t3, 0, 0, 2, 0LL);
    xsi_set_current_line(38, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(38, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(38, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB26;

LAB22:    xsi_set_current_line(39, ng0);

LAB29:    xsi_set_current_line(39, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t4, t3, 0, 0, 2, 0LL);
    xsi_set_current_line(39, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(39, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(39, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB26;

LAB24:    xsi_set_current_line(40, ng0);

LAB30:    xsi_set_current_line(40, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t4, t3, 0, 0, 2, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(40, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB26;

LAB33:    xsi_set_current_line(46, ng0);

LAB42:    xsi_set_current_line(46, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB41;

LAB35:    xsi_set_current_line(47, ng0);

LAB43:    xsi_set_current_line(47, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB41;

LAB37:    xsi_set_current_line(48, ng0);

LAB44:    xsi_set_current_line(48, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(48, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(48, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(48, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB41;

LAB39:    xsi_set_current_line(49, ng0);

LAB45:    xsi_set_current_line(49, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(49, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(49, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(49, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB41;

LAB47:    xsi_set_current_line(55, ng0);

LAB50:    xsi_set_current_line(56, ng0);
    t5 = (t0 + 1824U);
    t16 = *((char **)t5);

LAB51:    t5 = ((char*)((ng4)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t5, 32);
    if (t18 == 1)
        goto LAB52;

LAB53:    t2 = ((char*)((ng3)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t2, 32);
    if (t18 == 1)
        goto LAB54;

LAB55:    t2 = ((char*)((ng8)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t2, 32);
    if (t18 == 1)
        goto LAB56;

LAB57:    t2 = ((char*)((ng2)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t2, 32);
    if (t18 == 1)
        goto LAB58;

LAB59:    t2 = ((char*)((ng9)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t2, 32);
    if (t18 == 1)
        goto LAB60;

LAB61:    t2 = ((char*)((ng10)));
    t18 = xsi_vlog_unsigned_case_compare(t16, 7, t2, 32);
    if (t18 == 1)
        goto LAB62;

LAB63:
LAB64:    goto LAB49;

LAB52:    xsi_set_current_line(58, ng0);

LAB65:    xsi_set_current_line(58, ng0);
    t19 = ((char*)((ng4)));
    t20 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 2, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB54:    xsi_set_current_line(59, ng0);

LAB66:    xsi_set_current_line(59, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB56:    xsi_set_current_line(60, ng0);

LAB67:    xsi_set_current_line(60, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB58:    xsi_set_current_line(61, ng0);

LAB68:    xsi_set_current_line(61, ng0);
    t4 = ((char*)((ng4)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB60:    xsi_set_current_line(64, ng0);

LAB69:    xsi_set_current_line(64, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB62:    xsi_set_current_line(65, ng0);

LAB70:    xsi_set_current_line(65, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng4)));
    t4 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t4, t2, 0, 0, 1, 0LL);
    goto LAB64;

LAB73:    xsi_set_current_line(72, ng0);

LAB86:    xsi_set_current_line(72, ng0);
    t5 = ((char*)((ng4)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(72, ng0);
    t2 = ((char*)((ng4)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(72, ng0);
    t2 = ((char*)((ng4)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(72, ng0);
    t2 = ((char*)((ng4)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

LAB75:    xsi_set_current_line(73, ng0);

LAB87:    xsi_set_current_line(73, ng0);
    t5 = ((char*)((ng3)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(73, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(73, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(73, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

LAB77:    xsi_set_current_line(74, ng0);

LAB88:    xsi_set_current_line(74, ng0);
    t5 = ((char*)((ng3)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

LAB79:    xsi_set_current_line(75, ng0);

LAB89:    xsi_set_current_line(75, ng0);
    t5 = ((char*)((ng3)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(75, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(75, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(75, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

LAB81:    xsi_set_current_line(77, ng0);

LAB90:    xsi_set_current_line(77, ng0);
    t5 = ((char*)((ng8)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(77, ng0);
    t2 = ((char*)((ng4)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(77, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(77, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

LAB83:    xsi_set_current_line(78, ng0);

LAB91:    xsi_set_current_line(78, ng0);
    t5 = ((char*)((ng8)));
    t19 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t19, t5, 0, 0, 2, 0LL);
    xsi_set_current_line(78, ng0);
    t2 = ((char*)((ng4)));
    t5 = (t0 + 3184);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(78, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3344);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(78, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 3504);
    xsi_vlogvar_wait_assign_value(t5, t2, 0, 0, 1, 0LL);
    goto LAB85;

}


extern void work_m_16152463970888391459_1158921438_init()
{
	static char *pe[] = {(void *)Always_23_0};
	xsi_register_didat("work_m_16152463970888391459_1158921438", "isim/coreTest_isim_beh.exe.sim/work/m_16152463970888391459_1158921438.didat");
	xsi_register_executes(pe);
}
