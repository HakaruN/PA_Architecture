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
static const char *ng0 = "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/PA_Core.v";
static int ng1[] = {1, 0};
static int ng2[] = {0, 0};
static const char *ng3 = "\n";
static const char *ng4 = "Global processor state Registers; PC: %d, RegisterBank: %d, Reset: %b";
static const char *ng5 = "\nFetch:\nFetched %b, Enable: %b";
static const char *ng6 = "\nParse:\nIs branch; A:%d, B:%d";
static const char *ng7 = "Format; A:%d, B:%d";
static const char *ng8 = "Opcode; A:%d, B:%d";
static const char *ng9 = "Reg; A:%d, B:%d";
static const char *ng10 = "Operand; A:%d, B:%d";
static const char *ng11 = "Enable; A:%b, B:%b";
static const char *ng12 = "\nDecode:\nOpcode; A:%d, B:%d";
static const char *ng13 = "FunctionType; A:%d, B:%d";
static const char *ng14 = "Primary operand; A:%d, B:%d";
static const char *ng15 = "Second operand; A:%d, B:%d";
static const char *ng16 = "Reg accesses (pr,pw,sr); A:%d,%d,%d, B:%d,%d,%d";
static const char *ng17 = "Enables; A:%d, B:%d";
static const char *ng18 = "\nReg Read:\nEnable; A:%b, B:%b";
static const char *ng19 = "IsWriteback; A:%b B:%b";
static const char *ng20 = "Is secondary immediate (0) or reg(1); A:%b, B:%b";
static const char *ng21 = "Reg writeback Address; A:%d, B:%d";
static const char *ng22 = "PrimOperand; A:%d, B:%d";
static const char *ng23 = "SecOperand; A:%d, B:%d";
static const char *ng24 = "\nReg write:\nwbEnable; A:%b, B:%b";
static const char *ng25 = "WbAddress; A:%d, B:%d";
static const char *ng26 = "WBData; A:%d, B:%d";
static const char *ng27 = "\nArithmatic In:\nEnable A:%b B:%b";
static const char *ng28 = "\nBranch in:\nenable: %b";
static const char *ng29 = "Opcode: %d";
static const char *ng30 = "Jump Offset:%d";
static const char *ng31 = "Jump Condition:%d";
static const char *ng32 = "\nRegframe In:\nenable: %b";
static const char *ng33 = "opcode: %d";



static void Always_201_0(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
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
    char *t28;
    char *t29;

LAB0:    t1 = (t0 + 14040U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(201, ng0);
    t2 = (t0 + 14608);
    *((int *)t2) = 1;
    t3 = (t0 + 14072);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(202, ng0);

LAB5:    xsi_set_current_line(203, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = ((char*)((ng1)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    t8 = (t4 + 4);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB9;

LAB6:    if (t18 != 0)
        goto LAB8;

LAB7:    *((unsigned int *)t6) = 1;

LAB9:    t22 = (t6 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (~(t23));
    t25 = *((unsigned int *)t6);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(209, ng0);

LAB14:    xsi_set_current_line(212, ng0);
    t2 = (t0 + 8568U);
    t3 = *((char **)t2);
    t2 = (t0 + 12648);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(213, ng0);
    t2 = (t0 + 8888U);
    t3 = *((char **)t2);
    t2 = (t0 + 12808);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 5, 0LL);
    xsi_set_current_line(214, ng0);
    t2 = (t0 + 9208U);
    t3 = *((char **)t2);
    t2 = (t0 + 12968);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 16, 0LL);

LAB12:    goto LAB2;

LAB8:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(204, ng0);

LAB13:    xsi_set_current_line(206, ng0);
    t28 = ((char*)((ng2)));
    t29 = (t0 + 13128);
    xsi_vlogvar_wait_assign_value(t29, t28, 0, 0, 16, 0LL);
    goto LAB12;

}

static void Always_221_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 14288U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(221, ng0);
    t2 = (t0 + 14624);
    *((int *)t2) = 1;
    t3 = (t0 + 14320);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(222, ng0);

LAB5:    xsi_set_current_line(224, ng0);
    xsi_vlogfile_write(1, 0, 0, ng3, 1, t0);
    xsi_set_current_line(225, ng0);
    t2 = (t0 + 13128);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 1368U);
    t6 = *((char **)t5);
    t5 = (t0 + 1208U);
    t7 = *((char **)t5);
    xsi_vlogfile_write(1, 0, 0, ng4, 4, t0, (char)118, t4, 16, (char)118, t6, 6, (char)118, t7, 1);
    xsi_set_current_line(228, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 1688U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng5, 3, t0, (char)118, t3, 60, (char)118, t4, 1);
    xsi_set_current_line(231, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 2008U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng6, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(232, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng7, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(233, ng0);
    t2 = (t0 + 2488U);
    t3 = *((char **)t2);
    t2 = (t0 + 2648U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng8, 3, t0, (char)118, t3, 7, (char)118, t4, 7);
    xsi_set_current_line(234, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng9, 3, t0, (char)118, t3, 5, (char)118, t4, 5);
    xsi_set_current_line(235, ng0);
    t2 = (t0 + 3128U);
    t3 = *((char **)t2);
    t2 = (t0 + 3288U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng10, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(236, ng0);
    t2 = (t0 + 3448U);
    t3 = *((char **)t2);
    t2 = (t0 + 3608U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng11, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(239, ng0);
    t2 = (t0 + 3768U);
    t3 = *((char **)t2);
    t2 = (t0 + 3928U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng12, 3, t0, (char)118, t3, 7, (char)118, t4, 7);
    xsi_set_current_line(240, ng0);
    t2 = (t0 + 4088U);
    t3 = *((char **)t2);
    t2 = (t0 + 4248U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng13, 3, t0, (char)118, t3, 2, (char)118, t4, 2);
    xsi_set_current_line(241, ng0);
    t2 = (t0 + 4408U);
    t3 = *((char **)t2);
    t2 = (t0 + 4568U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng14, 3, t0, (char)118, t3, 5, (char)118, t4, 5);
    xsi_set_current_line(242, ng0);
    t2 = (t0 + 4728U);
    t3 = *((char **)t2);
    t2 = (t0 + 4888U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng15, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(243, ng0);
    t2 = (t0 + 5048U);
    t3 = *((char **)t2);
    t2 = (t0 + 5208U);
    t4 = *((char **)t2);
    t2 = (t0 + 5368U);
    t5 = *((char **)t2);
    t2 = (t0 + 5528U);
    t6 = *((char **)t2);
    t2 = (t0 + 5688U);
    t7 = *((char **)t2);
    t2 = (t0 + 5848U);
    t8 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng16, 7, t0, (char)118, t3, 1, (char)118, t4, 1, (char)118, t5, 1, (char)118, t6, 1, (char)118, t7, 1, (char)118, t8, 1);
    xsi_set_current_line(244, ng0);
    t2 = (t0 + 6008U);
    t3 = *((char **)t2);
    t2 = (t0 + 6168U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng17, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(247, ng0);
    t2 = (t0 + 6328U);
    t3 = *((char **)t2);
    t2 = (t0 + 6488U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng18, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(248, ng0);
    t2 = (t0 + 6648U);
    t3 = *((char **)t2);
    t2 = (t0 + 6808U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng19, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(249, ng0);
    t2 = (t0 + 5368U);
    t3 = *((char **)t2);
    t2 = (t0 + 5848U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng20, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(250, ng0);
    t2 = (t0 + 6968U);
    t3 = *((char **)t2);
    t2 = (t0 + 7128U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng21, 3, t0, (char)118, t3, 5, (char)118, t4, 5);
    xsi_set_current_line(251, ng0);
    t2 = (t0 + 7288U);
    t3 = *((char **)t2);
    t2 = (t0 + 7448U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng8, 3, t0, (char)118, t3, 7, (char)118, t4, 7);
    xsi_set_current_line(252, ng0);
    t2 = (t0 + 7608U);
    t3 = *((char **)t2);
    t2 = (t0 + 7768U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng22, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(253, ng0);
    t2 = (t0 + 7928U);
    t3 = *((char **)t2);
    t2 = (t0 + 8088U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng23, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(256, ng0);
    t2 = (t0 + 8568U);
    t3 = *((char **)t2);
    t2 = (t0 + 8728U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng24, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(257, ng0);
    t2 = (t0 + 8888U);
    t3 = *((char **)t2);
    t2 = (t0 + 9048U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng25, 3, t0, (char)118, t3, 5, (char)118, t4, 5);
    xsi_set_current_line(258, ng0);
    t2 = (t0 + 9208U);
    t3 = *((char **)t2);
    t2 = (t0 + 9368U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng26, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(263, ng0);
    t2 = (t0 + 9528U);
    t3 = *((char **)t2);
    t2 = (t0 + 9688U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng27, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(264, ng0);
    t2 = (t0 + 9848U);
    t3 = *((char **)t2);
    t2 = (t0 + 10008U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng19, 3, t0, (char)118, t3, 1, (char)118, t4, 1);
    xsi_set_current_line(265, ng0);
    t2 = (t0 + 10488U);
    t3 = *((char **)t2);
    t2 = (t0 + 10648U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng8, 3, t0, (char)118, t3, 7, (char)118, t4, 7);
    xsi_set_current_line(266, ng0);
    t2 = (t0 + 10808U);
    t3 = *((char **)t2);
    t2 = (t0 + 11128U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng22, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(267, ng0);
    t2 = (t0 + 10968U);
    t3 = *((char **)t2);
    t2 = (t0 + 11288U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng23, 3, t0, (char)118, t3, 16, (char)118, t4, 16);
    xsi_set_current_line(268, ng0);
    t2 = (t0 + 10168U);
    t3 = *((char **)t2);
    t2 = (t0 + 10328U);
    t4 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng25, 3, t0, (char)118, t3, 5, (char)118, t4, 5);
    xsi_set_current_line(271, ng0);
    t2 = (t0 + 11448U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng28, 2, t0, (char)118, t3, 1);
    xsi_set_current_line(272, ng0);
    t2 = (t0 + 11608U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng29, 2, t0, (char)118, t3, 7);
    xsi_set_current_line(273, ng0);
    t2 = (t0 + 11768U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng30, 2, t0, (char)118, t3, 16);
    xsi_set_current_line(274, ng0);
    t2 = (t0 + 11928U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng31, 2, t0, (char)118, t3, 16);
    xsi_set_current_line(277, ng0);
    t2 = (t0 + 12088U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng32, 2, t0, (char)118, t3, 1);
    xsi_set_current_line(278, ng0);
    t2 = (t0 + 12248U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng33, 2, t0, (char)118, t3, 7);
    xsi_set_current_line(281, ng0);
    xsi_vlogfile_write(1, 0, 0, ng3, 1, t0);
    goto LAB2;

}


extern void work_m_11878413109932374157_1926144903_init()
{
	static char *pe[] = {(void *)Always_201_0,(void *)Always_221_1};
	xsi_register_didat("work_m_11878413109932374157_1926144903", "isim/coreTest_isim_beh.exe.sim/work/m_11878413109932374157_1926144903.didat");
	xsi_register_executes(pe);
}
