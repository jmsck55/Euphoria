# OpenWatcom makefile for Euphoria (Win32/DOS32)
#
# You must first run configure.bat, supplying any options you might need:
#
#     --without-euphoria      Use this option if you are building Euphoria 
#		     with only a C compiler.
# 
#     --prefix <dir>  Use this option to specify the location for euphoria to
#		     be installed.  The default is EUDIR, or c:\euphoria,
#		     if EUDIR is not set.
#
#     --eubin <dir>   Use this option to specify the location of the interpreter
#		     binary to use to translate the front end.  The default
#		     is ..\bin
#
#     --managed-mem   Use this option to turn EUPHORIA's memory cache on in
#		     the targets
#
#     --debug	 Use this option to turn on debugging symbols
#
#
#     --full	  Use this option to so EUPHORIA doesn't report itself
#		     as a development version.
#
# Syntax:
#   Interpreter (euiw.exe, eui.exe):  wmake -f makefile.wat interpreter
#   Translator   (eucd.exe euc.exe):  wmake -f makefile.wat translator
#   Translator Library     (eu.lib):  wmake -f makefile.wat library
#   Translator Library    (eud.lib):  wmake -f makefile.wat library OS=DOS MANAGED_MEM=1
#   Backend	         (eubw.exe):  wmake -f makefile.wat backend
#		          (eub.exe)
#	           Make all targets:  wmake -f makefile.wat
#		             	      wmake -f makefile.wat all
#           Make all Win32 Binaries:  wmake -f makefile.wat winall
#           Make all Dos32 Binaries:  wmake -f makefile.wat dosall
#
#   Make C sources so this tree      
#   can be built with just a	 
#   compiler.  Note that translate   
#   creates c files for both DOS 
#   and Windows	                 :  wmake -f makefile.wat translate
#				    wmake -f makefile.wat translate-win  
#				    wmake -f makefile.wat translate-dos 
#
#      Install binaries, source and 
#		    include files:
#	     Windows and dos files  wmake -f makefile.wat install
#		Windows files only  wmake -f makefile.wat installwin
#		    dos files only  wmake -f makefile.wat installdos
#
#		   Run unit tests:
#		     Win32 and DOS  wmake -f makefile.wat test
#			Win32 Only  wmake -f makefile.wat testwin
#			  DOS Only  wmake -f makefile.wat testdos
#
# The source targets will create a subdirectory called euphoria-r$(SVN_REV). 
# The default for SVN_REV is 'xxx'.
#
#
#   Options:
#		    MANAGED_MEM:  Set this to 1 to use Euphoria's memory cache.
#				  The default is to use straight HeapAlloc/HeapFree calls. ex:
#				      wmake -h -f makefile.wat interpreter MANAGED_MEM=1
#
#			  DEBUG:  Set this to 1 to build debug versions of the targets.  ex:
#				      wmake -h -f makefile.wat interpreter DEBUG=1
#
!ifndef CONFIG
CONFIG=config.wat
!endif
!include $(CONFIG)

BASEPATH=pcre
!include $(BASEPATH)\objects.wat
!include $(TRUNKDIR)\source\version.mak

FULLBUILDDIR=$(BUILDDIR)

EU_CORE_FILES = &
	main.e &
	global.e &
	common.e &
	mode.e &
	pathopen.e &
	platform.e &
	error.e &
	symtab.e &
	scanner.e &
	scinot.e &
	emit.e &
	parser.e &
	opnames.e &
	reswords.e &
	keylist.e &
	fwdref.e &
	shift.e &
	inline.e &
	block.e

EU_INTERPRETER_FILES = &
	compress.e &
	backend.e &
	c_out.e &
	cominit.e &
	intinit.e &
	$(TRUNKDIR)\include\std\get.e &
	int.ex

EU_TRANSLATOR_FILES = &
	compile.e &
	ec.ex &
	c_decl.e &
	c_out.e &
	cominit.e &
	traninit.e &
	compress.e
	
!include $(BUILDDIR)\transobj.wat
!include $(BUILDDIR)\intobj.wat
!include $(BUILDDIR)\backobj.wat
!include $(BUILDDIR)\dosobj.wat
!include $(BUILDDIR)\dostrobj.wat
!include $(BUILDDIR)\dosbkobj.wat

EU_BACKEND_OBJECTS = &
!ifneq INT_CODES 1
	$(BUILDDIR)\$(OBJDIR)\back\be_magic.obj &
!endif	
	$(BUILDDIR)\$(OBJDIR)\back\be_execute.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_decompress.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_task.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_main.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_alloc.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_callc.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_inline.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_machine.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_rterror.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_syncolor.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_runtime.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_symtab.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_w.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_socket.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_pcre.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_rev.obj &
	$(PCRE_OBJECTS)
#       &
#       $(BUILDDIR)\$(OBJDIR)\memory.obj

EU_LIB_OBJECTS = &
	$(BUILDDIR)\$(OBJDIR)\back\be_decompress.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_machine.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_w.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_alloc.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_inline.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_runtime.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_task.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_callc.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_socket.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_pcre.obj &
	$(BUILDDIR)\$(OBJDIR)\back\be_rev.obj &
	$(PCRE_OBJECTS)

EU_BACKEND_RUNNER_FILES = &
	.\backend.ex &
	.\compress.e &
	.\reswords.e &
	.\common.e &
	.\cominit.e &
	.\pathopen.e


EU_INCLUDES = $(TRUNKDIR)\include\std\*.e $(TRUNKDIR)\include\*.e &
		$(TRUNKDIR)\include\euphoria\*.e

EU_ALL_FILES = *.e $(EU_INCLUDES) &
		 int.ex ec.ex backend.ex

!ifneq MANAGED_MEM 1
MEMFLAG = /dESIMPLE_MALLOC
!else
MANAGED_FLAG = -D EU_MANAGED_MEM
!endif

!ifeq RELEASE 1
RELEASE_FLAG = -D EU_FULL_RELEASE
!endif

!ifndef EUBIN
EUBIN=$(TRUNKDIR)\bin
!endif

!ifndef PREFIX
!ifneq PREFIX ""
PREFIX=$(%EUDIR)
!else
PREFIX=C:\euphoria
!endif
!endif

!ifndef BUILDDIR
BUILDDIR=.
!endif

!ifeq INT_CODES 1
#TODO hack
MEMFLAG = $(MEMFLAG) /dINT_CODES
!endif

!ifeq DEBUG 1
DEBUGFLAG = /d2 /dEDEBUG 
#DEBUGFLAG = /d2 /dEDEBUG /dDEBUG_OPCODE_TRACE
DEBUGLINK = debug all
EUDEBUG=-D DEBUG
!endif

!ifeq HEAP_CHECK 1
HEAPCHECKFLAG=/dHEAP_CHECK
!endif

!ifndef EX
EX=$(EUBIN)\eui.exe
!endif

EXE=$(EX)
INCDIR=-i $(TRUNKDIR)\include

PWD=$(%cdrive):$(%cwd)

VARS=DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM) CONFIG=$(CONFIG)
all :  .SYMBOLIC
    @echo ------- ALL -----------
	wmake -h -f makefile.wat winall $(VARS)
	wmake -h -f makefile.wat dosall $(VARS)

winall : .SYMBOLIC
    @echo ------- WINALL -----------
	wmake -h -f makefile.wat interpreter $(VARS)
	wmake -h -f makefile.wat translator $(VARS)
	wmake -h -f makefile.wat winlibrary $(VARS)
	wmake -h -f makefile.wat backend $(VARS)

dosall : .SYMBOLIC 
    @echo ------- DOSALL -----------
	wmake -h -f makefile.wat dos  $(VARS) MANAGED_MEM=1
	wmake -h -f makefile.wat library  $(VARS) MANAGED_MEM=1 OS=DOS
	wmake -h -f makefile.wat dostranslator  $(VARS) MANAGED_MEM=1 
	wmake -h -f makefile.wat dosbackend  $(VARS) MANAGED_MEM=1

BUILD_DIRS=$(BUILDDIR)\intobj $(BUILDDIR)\transobj $(BUILDDIR)\DOSlibobj $(BUILDDIR)\WINlibobj $(BUILDDIR)\backobj $(BUILDDIR)\dosbkobj $(BUILDDIR)\dosobj $(BUILDDIR)\dostrobj

distclean : .SYMBOLIC clean
!ifndef RM
	@ECHO Please run configure
	error
!endif
	cd pcre
	wmake -f makefile.wat clean
	cd ..
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RM) %i\back\*.*	
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RMDIR) %i\back
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RM) %i\*.*	
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RMDIR) %i
	-@for %i in ($(BUILD_DIRS)) do -$(RM) %i.wat
	-$(RM) $(CONFIG)
	-$(RM) pcre\pcre.h
	-$(RM) pcre\config.h
	-$(RM) version.h

clean : .SYMBOLIC
!ifndef DELTREE
	@ECHO Please run configure
	error
!endif
	-$(RM) &
	$(BUILDDIR)\euid.exe $(BUILDDIR)\eucd.exe $(BUILDDIR)\euiw.exe $(BUILDDIR)\eui.exe $(BUILDDIR)\euc.exe $(BUILDDIR)\eud.lib $(BUILDDIR)\eu.lib $(BUILDDIR)\eubw.exe $(BUILDDIR)\eub.exe $(BUILDDIR)\eubd.exe $(BUILDDIR)\main-.h $(BUILDDIR)\*.sym
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RM) %i\back\*.obj
	-@for %i in ($(BUILDDIR)\libobj $(BUILDDIR)\winlibobj $(BUILDDIR)\doslibobj) do -$(RMDIR) %i\back
	-@for %i in ($(BUILD_DIRS) $(BUILDDIR)\libobj) do -$(RM) %i\*.*
	-@for %i in ($(BUILDDIR)\libobj $(BUILDDIR)\winlibobj $(BUILDDIR)\doslibobj) do -$(RMDIR) %i
	cd pcre
	wmake -f makefile.wat clean
	cd ..

$(BUILD_DIRS) : .existsonly
	mkdir $@
	mkdir $@\back

!ifeq OS DOS
OSFLAG=EDOS
LIBTARGET=$(BUILDDIR)\eud.lib
!else
OS=WIN
OSFLAG=EWINDOWS
LIBTARGET=$(BUILDDIR)\eu.lib
!endif

CC = wcc386
!ifeq OS DOS
FE_FLAGS = /w0 /zq /j /zp4 /fpc /5r /otimra /s $(MEMFLAG) $(DEBUGFLAG) $(HEAPCHECKFLAG) /i..\
BE_FLAGS = /w0 /zq /j /zp4 /fpc /5r /ol /zp4 /d$(OSFLAG) /dEWATCOM  /dEOW $(%ERUNTIME) $(%EBACKEND) $(MEMFLAG) $(DEBUGFLAG) $(HEAPCHECKFLAG)
!else
FE_FLAGS = /bt=nt /mf /w0 /zq /j /zp4 /fp5 /fpi87 /5r /otimra /s $(MEMFLAG) $(DEBUGFLAG) $(HEAPCHECKFLAG) /I..\
BE_FLAGS = /ol /zp8 /d$(OSFLAG) /dEWATCOM  /dEOW $(%ERUNTIME) $(%EBACKEND) $(MEMFLAG) $(DEBUGFLAG) $(HEAPCHECKFLAG)
!endif
	
library : .SYMBOLIC version.h runtime
    @echo ------- LIBRARY -----------
	wmake -h -f makefile.wat $(LIBTARGET) OS=$(OS) OBJDIR=$(OS)libobj $(VARS) MANAGED_MEM=$(MANAGED_MEM)

doslibrary : .SYMBOLIC 
    @echo ------- DOS LIBRARY -----------
	wmake -h -f makefile.wat OS=DOS library  $(VARS)

winlibrary : .SYMBOLIC
    @echo ------- WINDOWS LIBRARY -----------
	wmake -h -f makefile.wat OS=WIN library  $(VARS)

runtime: .SYMBOLIC 
    @echo ------- RUNTIME -----------
	set ERUNTIME=/dERUNTIME

backendflag: .SYMBOLIC
	set EBACKEND=/dBACKEND

$(BUILDDIR)\eu.lib : $(BUILDDIR)\$(OBJDIR)\back $(EU_LIB_OBJECTS)
	wlib -q $(BUILDDIR)\eu.lib $(EU_LIB_OBJECTS)

$(BUILDDIR)\eud.lib : $(BUILDDIR)\$(OBJDIR)\back $(EU_LIB_OBJECTS)
	wlib -q $(BUILDDIR)\eud.lib $(EU_LIB_OBJECTS)


!ifdef OBJDIR

objlist : .SYMBOLIC
	wmake -h -f Makefile.wat $(VARS) OS=$(OS) EU_NAME_OBJECT=$(EU_NAME_OBJECT) OBJDIR=$(OBJDIR) $(BUILDDIR)\$(OBJDIR).wat EX=$(EUBIN)\eui.exe

    
$(BUILDDIR)\$(OBJDIR)\back : .EXISTSONLY $(BUILDDIR)\$(OBJDIR)
    -mkdir $(BUILDDIR)\$(OBJDIR)\back

$(BUILDDIR)\$(OBJDIR).wat : $(BUILDDIR)\$(OBJDIR)\main-.c &
!ifneq INT_CODES 1
$(BUILDDIR)\$(OBJDIR)\back\be_magic.c
!else

!endif
	@if exist $(BUILDDIR)\objtmp rmdir /Q /S $(BUILDDIR)\objtmp
	@mkdir $(BUILDDIR)\objtmp
	@copy $(BUILDDIR)\$(OBJDIR)\*.c $(BUILDDIR)\objtmp
	@cd $(BUILDDIR)\objtmp
	ren *.c *.obj
	%create $(OBJDIR).wat
	%append $(OBJDIR).wat $(EU_NAME_OBJECT) = &  
	for %i in (*.obj) do @%append $(OBJDIR).wat $(BUILDDIR)\$(OBJDIR)\%i & 
	%append $(OBJDIR).wat    
	del *.obj
	cd $(TRUNKDIR)\source
	move $(BUILDDIR)\objtmp\$(OBJDIR).wat $(BUILDDIR)
	rmdir $(BUILDDIR)\objtmp


exwsource : .SYMBOLIC version.h $(BUILDDIR)\$(OBJDIR)\main-.c
ecwsource : .SYMBOLIC version.h $(BUILDDIR)\$(OBJDIR)\main-.c
backendsource : .SYMBOLIC version.h $(BUILDDIR)\$(OBJDIR)\main-.c
ecsource : .SYMBOLIC version.h $(BUILDDIR)\$(OBJDIR)\main-.c
exsource : .SYMBOLIC version.h $(BUILDDIR)\$(OBJDIR)\main-.c

!endif
# OBJDIR

!ifdef EUPHORIA
translate-win : .SYMBOLIC  
    @echo ------- TRANSLATE WIN -----------
	$wmake -h -f makefile.wat exwsource EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=intobj DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)  $(VARS)
	wmake -h -f makefile.wat ecwsource EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=transobj DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)  $(VARS)
	wmake -h -f makefile.wat backendsource EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=backobj DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)  $(VARS)
	
translate-dos : .SYMBOLIC 
    @echo ------- TRANSLATE DOS -----------
	wmake -h -f makefile.wat exsource EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=dosobj  $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS 
	wmake -h -f makefile.wat ecsource EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=dostrobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS
	wmake -h -f makefile.wat backendsource EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=dosbkobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS
	
translate : .SYMBOLIC translate-win translate-dos


testwin : .SYMBOLIC
	cd ..\tests
	set EUDIR=$(TRUNKDIR) 
	$(EUBIN)\eui.exe ..\source\eutest.ex -i ..\include -cc wat -exe $(FULLBUILDDIR)\eui.exe -ec $(FULLBUILDDIR)\euc.exe -lib $(FULLBUILDDIR)\eu.lib
	cd ..\source

testdos : .SYMBOLIC dos
	cd ..\tests
	set EUDIR=$(TRUNKDIR)
	$(EUBIN)\euid.exe ..\source\eutest.ex -i ..\include -cc wat -exe $(FULLBUILDDIR)\euid.exe -ec $(FULLBUILDDIR)\eucd.exe -lib $(FULLBUILDDIR)\eud.lib
	cd ..\source
	
test : .SYMBOLIC testwin testdos

!endif #EUPHORIA	

$(BUILDDIR)\eui.exe $(BUILDDIR)\euiw.exe: $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_CORE_OBJECTS) $(EU_INTERPRETER_OBJECTS) $(EU_BACKEND_OBJECTS) 
	@%create $(BUILDDIR)\$(OBJDIR)\euiw.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\euiw.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\euiw.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\euiw.lbc library ws2_32
	@for %i in ($(EU_CORE_OBJECTS) $(EU_INTERPRETER_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\euiw.lbc file %i
	wlink  $(DEBUGLINK) SYS nt op maxe=25 op q op symf op el @$(BUILDDIR)\$(OBJDIR)\euiw.lbc name $(BUILDDIR)\eui.exe
	wrc -q -ad exw.res $(BUILDDIR)\eui.exe
	wlink $(DEBUGLINK) SYS nt_win op maxe=25 op q op symf op el @$(BUILDDIR)\$(OBJDIR)\euiw.lbc name $(BUILDDIR)\euiw.exe
	wrc -q -ad exw.res $(BUILDDIR)\euiw.exe

interpreter : .SYMBOLIC version.h
	wmake -h -f makefile.wat $(BUILDDIR)\intobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=intobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)
	wmake -h -f makefile.wat objlist OBJDIR=intobj $(VARS) EU_NAME_OBJECT=EU_INTERPRETER_OBJECTS
	wmake -h -f makefile.wat $(BUILDDIR)\euiw.exe EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=intobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)
	wmake -h -f makefile.wat $(BUILDDIR)\eui.exe EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=intobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)

install-generic : .SYMBOLIC
	@echo --------- install-generic $(PREFIX) ------------
	if /I $(PWD)==$(PREFIX)\source exit
	for %i in (*.e) do @copy %i $(PREFIX)\source\
	for %i in (*.ex) do @copy %i $(PREFIX)\source\
	if not exist $(PREFIX)\include\std mkdir $(PREFIX)\include\std
	copy ..\include\* $(PREFIX)\include\
	copy ..\include\std\* $(PREFIX)\include\std
	if not exist $(PREFIX)\include\euphoria mkdir $(PREFIX)\include\euphoria
	copy ..\include\euphoria\* $(PREFIX)\include\euphoria
	
	
	
installwin : .SYMBOLIC install-generic installwinbin
	@echo --------- installwin $(PREFIX) ------------

installwinbin : .SYMBOLIC
	@echo --------- installwinbin $(PREFIX) ------------
	@if exist $(BUILDDIR)\euc.exe copy $(BUILDDIR)\euc.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\euiw.exe copy $(BUILDDIR)\euiw.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eui.exe copy $(BUILDDIR)\eui.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eubw.exe copy $(BUILDDIR)\eubw.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eub.exe copy $(BUILDDIR)\eub.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eu.lib copy $(BUILDDIR)\eu.lib $(PREFIX)\bin\

installdos : .SYMBOLIC install-generic installdosbin
	@echo --------- installdos $(PREFIX) ------------
	
installdosbin : .SYMBOLIC
	@echo --------- installdosbin $(PREFIX) ------------
	@if exist $(BUILDDIR)\euid.exe copy $(BUILDDIR)\euid.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eucd.exe copy $(BUILDDIR)\eucd.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eubd.exe copy $(BUILDDIR)\eubd.exe $(PREFIX)\bin\
	@if exist $(BUILDDIR)\eud.lib copy $(BUILDDIR)\eud.lib $(PREFIX)\bin\
	
install : .SYMBOLIC installwin installdos
	@echo --------- install $(PREFIX) ------------
	
installbin : .SYMBOLIC installwinbin installdosbin
	@echo --------- installbin $(PREFIX) ------------
	
	
$(BUILDDIR)\euc.exe : $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_CORE_OBJECTS) $(EU_TRANSLATOR_OBJECTS) $(EU_BACKEND_OBJECTS)
	@%create $(BUILDDIR)\$(OBJDIR)\euc.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\euc.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\euc.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\euc.lbc library ws2_32
	@for %i in ($(EU_CORE_OBJECTS) $(EU_TRANSLATOR_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\euc.lbc file %i
	wlink $(DEBUGLINK) SYS nt op maxe=25 op q op symf op el @$(BUILDDIR)\$(OBJDIR)\euc.lbc name $(BUILDDIR)\euc.exe
	wrc -q -ad exw.res $(BUILDDIR)\euc.exe


translator : .SYMBOLIC version.h
    @echo ------- TRANSLATOR -----------
	wmake -h -f makefile.wat $(BUILDDIR)\transobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=transobj  $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)
	wmake -h -f makefile.wat objlist OBJDIR=transobj EU_NAME_OBJECT=EU_TRANSLATOR_OBJECTS $(VARS)
	wmake -h -f makefile.wat $(BUILDDIR)\euc.exe EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=transobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)

dostranslator : .SYMBOLIC version.h
    @echo ------- DOS TRANSLATOR -----------
	wmake -h -f makefile.wat $(BUILDDIR)\dostrobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=dostrobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS
	wmake -h -f makefile.wat objlist OBJDIR=dostrobj EU_NAME_OBJECT=EU_TRANSDOS_OBJECTS $(VARS) OS=DOS
	wmake -h -f makefile.wat $(BUILDDIR)\eucd.exe EX=$(EUBIN)\eui.exe EU_TARGET=ec. OBJDIR=dostrobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS

$(BUILDDIR)\eubw.exe :  $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_BACKEND_RUNNER_OBJECTS) $(EU_BACKEND_OBJECTS)
    @echo ------- BACKEND WIN -----------
	@%create $(BUILDDIR)\$(OBJDIR)\eub.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\eub.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\eub.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\eub.lbc library ws2_32
	@for %i in ($(EU_BACKEND_RUNNER_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\eub.lbc file %i
	wlink $(DEBUGLINK) SYS nt_win op maxe=25 op q op symf op el @$(BUILDDIR)\$(OBJDIR)\eub.lbc name $(BUILDDIR)\eubw.exe
	wrc -q -ad exw.res $(BUILDDIR)\eubw.exe
	wlink $(DEBUGLINK) SYS nt op maxe=25 op q op symf op el @$(BUILDDIR)\$(OBJDIR)\eub.lbc name $(BUILDDIR)\eub.exe
	wrc -q -ad exw.res $(BUILDDIR)\eub.exe


backend : .SYMBOLIC version.h backendflag
    @echo ------- BACKEND -----------
	wmake -h -f makefile.wat $(BUILDDIR)\backobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=backobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)
	wmake -h -f makefile.wat objlist OBJDIR=backobj EU_NAME_OBJECT=EU_BACKEND_RUNNER_OBJECTS $(VARS)
	wmake -h -f makefile.wat $(BUILDDIR)\eubw.exe EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=backobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=$(MANAGED_MEM)

dosbackend : .SYMBOLIC version.h backendflag
    @echo ------- BACKEND -----------
	wmake -h -f makefile.wat $(BUILDDIR)\dosbkobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=dosbkobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS
	wmake -h -f makefile.wat objlist OBJDIR=dosbkobj EU_NAME_OBJECT=EU_DOSBACKEND_RUNNER_OBJECTS $(VARS) OS=DOS
	wmake -h -f makefile.wat $(BUILDDIR)\eubd.exe EX=$(EUBIN)\eui.exe EU_TARGET=backend. OBJDIR=dosbkobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS

dos : .SYMBOLIC version.h
    @echo ------- DOS -----------
	wmake -h -f makefile.wat $(BUILDDIR)\dosobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=dosobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS
	wmake -h -f makefile.wat objlist OBJDIR=dosobj EU_NAME_OBJECT=EU_DOS_OBJECTS $(VARS) OS=DOS
	wmake -h -f makefile.wat $(BUILDDIR)\euid.exe EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=dosobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS

doseubin : .SYMBOLIC version.h
    @echo ------- DOS EUBIN -----------
	wmake -h -f makefile.wat $(BUILDDIR)\dosobj\main-.c EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=dosobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS DOSEUBIN="-WAT -PLAT DOS"
	wmake -h -f makefile.wat objlist OBJDIR=dosobj EU_NAME_OBJECT=EU_DOS_OBJECTS $(VARS) OS=DOS
	wmake -h -f makefile.wat $(BUILDDIR)\euid.exe EX=$(EUBIN)\eui.exe EU_TARGET=int. OBJDIR=dosobj $(VARS) DEBUG=$(DEBUG) MANAGED_MEM=1 OS=DOS DOSEUBIN="-WAT -PLAT DOS"

$(BUILDDIR)\eubd.exe : $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_DOSBACKEND_RUNNER_OBJECTS) $(EU_BACKEND_OBJECTS)
    @echo ------- DOS BACKEND -----------
	@%create $(BUILDDIR)\$(OBJDIR)\eubd.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc option osname='CauseWay'
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc libpath $(%WATCOM)\lib386
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc libpath $(%WATCOM)\lib386\dos
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc OPTION stub=$(%WATCOM)\binw\cwstub.exe
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc format os2 le ^
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc OPTION STACK=262144
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc OPTION QUIET
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc OPTION ELIMINATE
	@%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc OPTION CASEEXACT
	@for %i in ($(EU_DOSBACKEND_RUNNER_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\eubd.lbc file %i
	wlink  $(DEBUGLINK) @$(BUILDDIR)\$(OBJDIR)\eubd.lbc name $(BUILDDIR)\eubd.exe
	cd $(BUILDDIR)
	le23p eubd.exe
	cwc eubd.exe
	cd $(TRUNKDIR)\source

$(BUILDDIR)\euid.exe : $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_DOS_OBJECTS) $(EU_BACKEND_OBJECTS)
    @echo ------- DOS INTERPRETER -----------
	@%create $(BUILDDIR)\$(OBJDIR)\euid.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc option osname='CauseWay'
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc libpath $(%WATCOM)\lib386
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc libpath $(%WATCOM)\lib386\dos
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc OPTION stub=$(%WATCOM)\binw\cwstub.exe
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc format os2 le ^
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc OPTION STACK=262144
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc OPTION QUIET
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc OPTION ELIMINATE
	@%append $(BUILDDIR)\$(OBJDIR)\euid.lbc OPTION CASEEXACT
	@for %i in ($(EU_DOS_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\euid.lbc file %i
	wlink  $(DEBUGLINK) @$(BUILDDIR)\$(OBJDIR)\euid.lbc name $(BUILDDIR)\euid.exe
	cd $(BUILDDIR)
	le23p euid.exe
	cwc euid.exe
	cd $(TRUNKDIR)\source

$(BUILDDIR)\eucd.exe : $(BUILDDIR)\$(OBJDIR)\main-.c $(EU_TRANSDOS_OBJECTS) $(EU_BACKEND_OBJECTS)
    @echo ------- DOS TRANSLATOR EXE -----------
	@%create $(BUILDDIR)\$(OBJDIR)\eucd.lbc
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc option quiet
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc option caseexact
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc option osname='CauseWay'
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc libpath $(%WATCOM)\lib386
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc libpath $(%WATCOM)\lib386\dos
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc OPTION stub=$(%WATCOM)\binw\cwstub.exe
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc format os2 le ^
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc OPTION STACK=262144
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc OPTION QUIET
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc OPTION ELIMINATE
	@%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc OPTION CASEEXACT
	@for %i in ($(EU_TRANSDOS_OBJECTS) $(EU_BACKEND_OBJECTS)) do @%append $(BUILDDIR)\$(OBJDIR)\eucd.lbc file %i
	wlink $(DEBUGLINK) @$(BUILDDIR)\$(OBJDIR)\eucd.lbc name $(BUILDDIR)\eucd.exe
	cd $(BUILDDIR)
	le23p eucd.exe
	cwc eucd.exe
	cd $(TRUNKDIR)\source

$(BUILDDIR)\intobj\main-.c: $(BUILDDIR)\intobj\back $(EU_CORE_FILES) $(EU_INTERPRETER_FILES) $(EU_INCLUDES)
$(BUILDDIR)\transobj\main-.c: $(BUILDDIR)\transobj\back $(EU_CORE_FILES) $(EU_TRANSLATOR_FILES) $(EU_INCLUDES)
$(BUILDDIR)\backobj\main-.c: $(BUILDDIR)\backobj\back $(EU_CORE_FILES) $(EU_BACKEND_RUNNER_FILES) $(EU_INCLUDES)
$(BUILDDIR)\dosobj\main-.c: $(BUILDDIR)\dosobj\back $(EU_CORE_FILES) $(EU_INTERPRETER_FILES) $(EU_INCLUDES)
$(BUILDDIR)\dostrobj\main-.c: $(BUILDDIR)\dostrobj\back $(EU_CORE_FILES) $(EU_TRANSLATOR_FILES) $(EU_INCLUDES)
$(BUILDDIR)\dosbkobj\main-.c: $(BUILDDIR)\dosbkobj\back $(EU_CORE_FILES) $(EU_BACKEND_RUNNER_FILES) $(EU_INCLUDES)

!ifdef EUPHORIA
# We should have ifdef EUPHORIA so that make doesn't decide
# to update rev.e when there is no $(EX)
be_rev.c : .recheck .always
	$(EX) -i ..\include revget.ex

!ifdef EU_TARGET
!ifdef OBJDIR
$(BUILDDIR)\$(OBJDIR)\main-.c : $(EU_TARGET)ex $(BUILDDIR)\$(OBJDIR)\back $(EU_TRANSLATOR_FILES)
	-$(RM) $(BUILDDIR)\$(OBJDIR)\back\*.*
	-$(RM) $(BUILDDIR)\$(OBJDIR)\*.*
	cd  $(BUILDDIR)\$(OBJDIR)
	$(EXE) $(INCDIR) $(EUDEBUG) $(TRUNKDIR)\source\ec.ex -wat -plat $(OS) $(RELEASE_FLAG) $(MANAGED_FLAG) $(DOSEUBIN) $(INCDIR) $(TRUNKDIR)\source\$(EU_TARGET)ex
	cd $(TRUNKDIR)\source

$(BUILDDIR)\$(OBJDIR)\$(EU_TARGET)c : $(EU_TARGET)ex  $(BUILDDIR)\$(OBJDIR)\back $(EU_TRANSLATOR_FILES)
	-$(RM) $(BUILDDIR)\$(OBJDIR)\back\*.*
	-$(RM) $(BUILDDIR)\$(OBJDIR)\*.*
	cd $(BUILDDIR)\$(OBJDIR)
	$(EXE) $(INCDIR) $(EUDEBUG) $(TRUNKDIR)\source\ec.ex -wat -plat $(OS) $(RELEASE_FLAG) $(MANAGED_FLAG) $(DOSEUBIN) $(INCDIR) $(TRUNKDIR)\source\$(EU_TARGET)ex
	cd $(TRUNKDIR)\source
!endif
!endif
!else
$(BUILDDIR)\$(OBJDIR)\main-.c $(BUILDDIR)\$(OBJDIR)\$(EU_TARGET)c : $(EU_TARGET)ex $(BUILDDIR)\$(OBJDIR)\back
	@echo *****************************************************************
	@echo If you have EUPHORIA installed you'll need to run configure again.
	@echo Make is configured to not try to use the interpreter.
	@echo *****************************************************************

!endif

.c: $(BUILDDIR)\$(OBJDIR);$(BUILDDIR)\$(OBJDIR)\back
.c.obj: 
	$(CC) $(FE_FLAGS) $(BE_FLAGS) $[@ -fo=$^@
	
$(BUILDDIR)\$(OBJDIR)\back\be_inline.obj : ./be_inline.c $(BUILDDIR)\$(OBJDIR)\back
	$(CC) /oe=40 $(BE_FLAGS) $(FE_FLAGS) $^&.c -fo=$^@

!ifneq INT_CODES 1
$(BUILDDIR)\$(OBJDIR)\back\be_magic.c :  $(BUILDDIR)\$(OBJDIR)\back\be_execute.obj $(TRUNKDIR)\source\findjmp.ex
	cd $(BUILDDIR)\$(OBJDIR)\back
	$(EXE) $(INCDIR) $(TRUNKDIR)\source\findjmp.ex
	cd $(TRUNKDIR)\source

$(BUILDDIR)\$(OBJDIR)\back\be_magic.obj : $(BUILDDIR)\$(OBJDIR)\back\be_magic.c
	$(CC) $(FE_FLAGS) $(BE_FLAGS) $[@ -fo=$^@
!endif

$(BUILDDIR)\$(OBJDIR)\back\be_execute.obj : be_execute.c *.h $(CONFIG)
$(BUILDDIR)\$(OBJDIR)\back\be_decompress.obj : be_decompress.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_task.obj : be_task.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_main.obj : be_main.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_alloc.obj : be_alloc.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_callc.obj : be_callc.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_inline.obj : be_inline.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_machine.obj : be_machine.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_rterror.obj : be_rterror.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_syncolor.obj : be_syncolor.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_runtime.obj : be_runtime.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_symtab.obj : be_symtab.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_w.obj : be_w.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_socket.obj : be_socket.c *.h $(CONFIG)
$(BUILDDIR)\$(OBJDIR)\back\be_pcre.obj : be_pcre.c *.h $(CONFIG) 
$(BUILDDIR)\$(OBJDIR)\back\be_rev.obj : be_rev.c *.h $(CONFIG) 

version.h: version.mak
    @echo ------- VERSION.H -----------
	@echo // DO NOT EDIT, EDIT version.mak INSTEAD > version.h
	@echo $#define MAJ_VER $(MAJ_VER) >> version.h
	@echo $#define MIN_VER $(MIN_VER) >> version.h
	@echo $#define PAT_VER $(PAT_VER) >> version.h
	@echo $#define REL_TYPE "$(REL_TYPE)" >> version.h

!ifdef PCRE_OBJECTS	
$(PCRE_OBJECTS) : pcre/*.c pcre/pcre.h.windows pcre/config.h.windows
    @echo ------- REG EXP -----------
	cd pcre
	wmake -h -f makefile.wat 
	cd ..
!endif
