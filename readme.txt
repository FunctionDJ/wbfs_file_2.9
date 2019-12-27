
wbfs_file v2.9 by oggzee
========================

Based on wbfs tool by kwiirk and wbfs_win by hermes


New functionality:
------------------
(compared to original wbfs by kwiirk)

* Conversion from .iso files to .wbfs files and vice versa.

* Handling of split .wbfs files, so that they can fit on a FAT filesystem.
  by default the split is done at 4GB - 32kb
  (32kb = 1 fat cluster and also 1 wii disc sector)

* Extraction of .wbfs files directly from a wbfs partition and back


FAQ:

Q: Can I extract all the games from a WBFS partition to .wbfs files?
A: Yes, use this command:
wbfs_file.exe W: extract_wbfs_all D:\wbfs
Where W: is your WBFS partition and D:\wbfs is the FAT partition on USB
(or any kind of filesystem on a local hard-disk)

Q: How to copy all .wbfs files back to a WBFS partition?
A: Open up CMD where your .wbfs files are and run:
for %i in (*.wbfs) do wbfs_file.exe W: add_wbfs "%i"

Q: How to convert all the .iso files to .wbfs files?
A: Open up CMD where your iso files are and run:
for %i in (*.iso) do wbfs_file.exe "%i"
Note: If you write that in a .bat batch file then
you have to use %%i instead of %i, like this:
for %%i in (*.iso) do wbfs_file.exe "%%i"

Q: How to create non-splitted .wbfs files?
A: Use -s 10000000000 option (or -0 option)
However note that files larger than 4GB cannot
be copied to a FAT filesystem partition.

Q: How to re-split the existing 2gb split files to 4gb split files?
A: Use the included resplit.bat batch file. But first it has to be
edited with proper locations for the 2 variables on top of the file:
 set WBFS_DIR=I:\wbfs
 set TEMP_DIR=D:\temp
Only the games that need to be resplit will be processed, so those
that are already a single .wbfs file will not be touched and those
that already use the 4gb-32kb split size will also not be touched.


Changes:
--------

v2.9:

 * Don't sync (write) headers on a wbfs partition when only
   reading from it to prevent any possibility of corruption.

v2.8:

 * More filename layout options:
     -l X     :  Layout of the destination filename:
                -l f0 = file: ID.ext             (same as -b)
                -l f1 = file: ID_TITLE.ext
                -l f2 = file: TITLE [ID].ext
                -l d0 = dir:  ID/ID.ext
                -l d1 = dir:  ID_TITLE/ID.ext    (same as -d)
                -l d2 = dir:  TITLE [ID]/ID.ext  [default]
   Note that not all layouts are supported by current loaders.
   Currently supported layouts in cfg loader:
   -l f0 : cfg loader v46+
   -l d1 : cfg loader v49+
   -l d2 : cfg loader v51+
   Layout -l d2 (TITLE [ID]/ID.ext) is now the default for both .iso and
   .wbfs file creation

 * Command id_title also accepts -l f0 .. f2 (but default is still ID_TITLE)

 * The ID_TITLE.txt info file creation is now disabled by default
   can be enabled with -x 1

 * More info in progress display:
   49.67% (-) ETA: 0:00:54 (2226.25MB of 4482.25MB ~ 41.82MB/s) time: 53.23s

 * Included more utility scripts:
    rename_folders-title [id].vbs
    rename_folders.vbs
    rename_titles_id.sh
    rename_titles.sh

v2.7:

 * Linux and MacOSX changes

v2.7-beta:

 * New command: wbfs_copy will copy a game directly from one wbfs
   partition to the other
 * New command: iso_info will print out some info about a wii disc
 * All commands that expect a ISO as source now also accept a device
   so that a DVD drive can be used directly
 * Commands writing to WBFS partition or file can now be aborted
   by sending ABORT<enter> to standard input

v2.6:

 * Fixed add_wbfs command for copying .wbfs files to WBFS partitions.
   (Problem was with WBFS partitions larger than 128GB,
	because of the different wbfs block sizes)

 * Command init now requires -f option to force formatting

 * Don't print sparse errors when writing .iso to FAT

v2.5:

 * Properly mark last scrubbed block as sparse when creating an .iso
   either by scrubbing or by converting from .wbfs (windows-only issue)
   (The file is the same but will use a little less space)

v2.4:

 * New option:
    -z       :  make zero filled used blocks as sparse when scrubbing
    (by default only unused (scrubbed) data is sparse)
 * Using the option -1 (copy 1:1) and the scrub command makes it a simple copy.
   Using scrub with -1 and -z makes it a generic sparse copy operation

v2.3:

 * Fixed scrub with -t option to properly pre-allocate trimmed size
   and enable sparse file mode.

v2.3-beta:

 * New command: scrub
   Will scrub the source .iso and write the destination .iso as a sparse file.
   Options that affect the created file: -u -t -d -b -g -a
   usage: wbfs_file.exe <filename.iso> scrub <DST:dir or file.iso>

 * New options:
    -u SIZE  :  Set scrub block size [32768] (1 wii sector)
                Must be a multiple of 32768 (wii sector size)
                Special values: 1=1 wii sector, 2=2mb (.wbfs block)

    -x 0|1   :  disable|enable .txt file creation

 * Included some fixes from wwt (by wiimm) for correct sector based scrubbing

 * Changed most of the options that previously accepted a destination directory
   to optionally accept a destination filename to avoid automatic file naming:

        <filename.iso>   convert  <DST:dir or file.wbfs>
        <filename.wbfs>  convert  <DST:dir or file.iso>
        <drive or file>  extract_iso      <GAMEID> <DST:dir or file.iso>
        <drive or file>  extract_wbfs     <GAMEID> <DST:dir or file.wbfs>

 * Naming of the destination .iso file when converting from .wbfs to .iso file 
   can now also be controlled using -b or -d options.
   (If none are specified the old naming is used: id_title.iso)

v2.2:
 * Fixed creation of directoris in case the title contained trailing space.
   Trailing space in directory is not allowed on windows so now it is trimmed.
 * Minor fixes to move_dirs.bat to better handle directories with spaces.
   (It still doesn't handle properly directories with exclamation marks '!')

v2.1:
 * Fixed file preallocation on windows.
   v2.0 caused the created files to contain additional blank padding
   and so was reported as inconsistent (hd num sector doesn't match)
   any .wbfs files created with v2.0 can be fixed by using:
   mkdir temp
   wbfs_file -f source.wbfs extract_wbfs_all temp
   then in temp should be the fixed file. (hopefully)

v2.0:
 * Prevent output file fragmentation by doing
   file preallocation for both .wbfs and .iso files.
 * id_title will accept an .iso or a .wbfs file
   and will no longer print the split file names, just the ID_TITLE string
 * Create GAMEID_TITLE subdirectories by default
   (this was previously enabled with -d option)
   To revert to previous behaviour use -b option:
 * new option
    -b       :  Use base directory for created .wbfs files
 * Included updated versions of a few utility scripts in
   the scripts directory:
        move_dirs.bat
        move_dirs.sh
        resplit.bat

v1.9:
 * new options:
    -d       :  Create a GAMEID_TITLE directory and place
                the created .wbfs file there
    -0       :  Don't split (split size: 10000000000)
 * new command: id_title
   will print the GAMEID_TITLE string suitable for the directory name
   (special characters :/\<>'"*? are replaced with _ space is kept)
 * included move_dirs.bat which will move *.wbfs files (and *.txt)
   to GAMEID_TITLE subdirectories

v1.8:
 * Included resplit.bat in the package
 * If the -s size is not 32kb aligned print only a warning instead of error.
   (It still has to be sector aligned or it will print an error)
 * Changed error message when reading inconsistent .wbfs files or partitions
   from:
        ERROR: reading 524288 [32768] from wbfs
        Probably corrupted. Use -f to force
   to:
        ERROR: reading 524288 [32768] from wbfs
        Possibly corrupted. Use -g to copy only game partition
   Unless -g is already specified in which case the original message is
   displayed. This is so that if only the update partition is corrupted
   one can still safely copy the game partition without risking corruption.

v1.7:
 * Changed extract_file filename to be non-case-sensitive
   and take an optional output file parameter:
   <drive or file>  extract_file  <GAMEID> <file> [<DST:file>]   
 * exit code from the program should now properly indicate an error

v1.6:
 * Changed default split size from 2gb-512b to 4gb-32kb
 * New option: -2 : use split size 2gb-32kb
 * New option: -4 : use split size 4gb-32kb (default)
 * Issue a warning if specified -s split size is not 32kb aligned.
 * Using option -f now allows to force wbfs extraction if the source
   wbfs is corrupted or has missing data - warning is printed and the
   block will be filled with 0.

v1.5:
 * Added more characters to the invalid path list: |<>
   Which are replaced with _. Full list: /\:|<>?*"' (tnx dekani)
 * Enabled debug_info command
 * Documented -f option
    -f       :  Force wbfs mode even if the wbfs file or partition
                integrity check is invalid (non matching number of
                sectors or other parameters)
 * Added option -t : trim extracted iso size
   (not recommended, is there any use for that?)

v1.4:
 * fixed -1 option for 1:1 copy.
   Note, a 1:1 copy will still scrub the last 256kb, because the wbfs
   block size (2 mb) is not aligned to the wii disc size (4699979776 b)
   However everything else is copied as is without scrubbing.
 * Replace also ? and * with _ when making a filename from title
 * make_info will create the .txt file in the same directory as the
   source .wbfs file unless the argument is a device, then the .txt
   files are created in the current dir.
 * Indicate in the help message which parameters are source (SRC:)
   and which are destination (DST:) in the first column, the parameter
   is a source unless DST: specified 
 * Added command: 'convert' which is the same as running the tool with
   just a filename, but it accepts a destination directory. Example:
     wbfs_file c:\wii\game.iso convert e:\wbfs
   will conver to e:\wbfs\GAMEID.wbfs
   While the single file parameter variant:
     wbfs_file c:\wii\game.iso
   will convert to c:\wii\GAMEID.wbfs

v1.3:
 * Fixed extracted iso size on Windows
 * Fixed ETA info for iso extraction

v1.2:
 * On Windows allow to use device name instead of drive letter in the format:
   \\?\GLOBALROOT\Device\Harddisk3\Partition2
   This is useful if you don't have a drive letter assigned to a partition

v1.1:
 * Added options:
    -a       :  Copy ALL partitions from ISO [default]
    -g       :  Copy only game partition from ISO
    -1       :  Copy 1:1 from ISO
   (Note: it's recommended to just use the defaults)

v1.0:
 * renamed commands for better clarity
   example: extractwbfsall to extract_wbfs_all ...

 * create GAMEID_TITLE.txt info files along GAMEID.wbfs files, so
   that it's easier to manage the .wbfs files

 * added command: make_info which only creates the GAMEID_TITLE.txt for
   all games on a wbfs partition or in a wbfs file

v0.9:
 * initial wbfs_file release with split file support


Usage help text as printed by wbfs_file -h :
--------------------------------------------

wbfs_file.exe 2.9 by oggzee, based on wbfs by kwiirk

Usage: wbfs_file.exe [OPTIONS] <DRIVE or FILENAME> [COMMAND [ARGS]]:

  Given just a filename it will convert from iso to wbfs or vice versa:

    wbfs_file.exe filename.iso
    Will convert filename.iso to GAMEID.wbfs
    And create an info file GAMEID_TITLE.txt

    wbfs_file.exe filename.wbfs
    Will convert filename.wbfs to GAMEID_TITLE.iso

  COMMANDS:
    <drive or file.iso>  convert  <DST:dir or file.wbfs>
        <filename.wbfs>  convert  <DST:dir or file.iso>
    <drive or file.iso>  scrub    <DST:dir or file.iso>
    <DST:filename.wbfs>  create   <SRC:drive or file.iso>
        <drive or file>  ls               
        <drive or file>  df               
        <drive or file>  make_info        
        <drive or file>  id_title         
    <DST:drive or file>  init             
    <DST:drive or file>  add_iso          <SRC:drive or file.iso>
    <DST:drive or file>  add_wbfs         <SRC:filename.wbfs>
    <DST:drive or file>  rm               <GAMEID>
        <drive or file>  extract_iso      <GAMEID> <DST:dir or file.iso>
        <drive or file>  extract_wbfs     <GAMEID> <DST:dir or file.wbfs>
        <drive or file>  extract_wbfs_all <DST:dir>
        <drive or file>  wbfs_copy        <GAMEID> <DST:drive or file.wbfs>
        <drive or file>  ls_file          <GAMEID>
        <drive or file>  extract_file     <GAMEID> <file> [<DST:file>]
        <drive or file>  debug_info       
        <drive or file>  iso_info

  OPTIONS: (it's recommended to just use the defaults)
    -s SIZE  :  Set split size [4294934528] (8388544 sectors)
                Must be a multiple of 512 (sector size)
    -2       :  Use split size: 2GB-32kb (2147450880)
    -4       :  Use split size: 4GB-32kb (4294934528)
    -0       :  Don't split (split size: 10000000000)
    -u SIZE  :  Set scrub block size [32768] (1 wii sector)
                Must be a multiple of 32768 (wii sector size)
                Special values: 1=1 wii sector, 2=2mb (.wbfs block)
    -z       :  make zero filled blocks as sparse when scrubbing
    -a       :  Copy ALL partitions from ISO [default]
    -g       :  Copy only game partition from ISO
    -1       :  Copy 1:1 from ISO
    -f       :  Force wbfs mode even if the wbfs file or partition
                integrity check is invalid (non matching number of
                sectors or other parameters)
    -t       :  trim extracted iso size
    -x 0|1   :  disable|enable .txt file creation [default:0]
    -l X     :  Layout of the destination filename:
                -l f0 = file: ID.ext             (same as -b)
                -l f1 = file: ID_TITLE.ext
                -l f2 = file: TITLE [ID].ext
                -l d0 = dir:  ID/ID.ext
                -l d1 = dir:  ID_TITLE/ID.ext    (same as -d)
                -l d2 = dir:  TITLE [ID]/ID.ext  [default]
    -b       :  Same as -l f0
    -d       :  Same as -l d1
    -h       :  Help

