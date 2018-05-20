FUNCTION avail_l1b2_data, misr_mode, path_pattern, misr_l1b2_data, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports on the availability of MISR L1B2 data
   ;  files in the subdirectories matching the IDL regular expression
   ;  path_pattern.
   ;
   ;  ALGORITHM: This function searches the path(s) matching the pattern
   ;  path_pattern for MISR L1B2 files. It stores information on their
   ;  names, sizes and range of temporal coverage in the output structure
   ;  misr_l1b2_data.
   ;
   ;  SYNTAX: rc = avail_l1b2_data(misr_mode, path_pattern, $
   ;  misr_l1b2_data, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: A 2-character parameter indicating
   ;      whether to report on the availability of Global (GM) or Local
   ;      (LM) Mode files.
   ;
   ;  *   path_pattern {STRING} [I]: A path pattern presumed to contain
   ;      MISR L1B2 data files.
   ;
   ;  *   misr_l1b2_data {STRUCTURE} [O]: A structure containing the names
   ;      of the subdirectories of path_pattern containing MISR L1B2
   ;      files, the total size of files in those directories, and the
   ;      range of dates covered by these data.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter
   ;      misr_l1b2_data is a structure containing information on the
   ;      availability of MISR L1B2 files in the appropriate folders of
   ;      root_dirs[1] at the time of execution.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter
   ;      misr_l1b2_data may be empty, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 120: Positional parameter path_pattern is not of type
   ;      STRING.
   ;
   ;  *   Error 130: Positional parameter path_pattern is not a directory
   ;      or is not accessible.
   ;
   ;  *   Error 140: An exception condition occurred in function is_dir.
   ;
   ;  *   Error 150: An exception condition occurred in function
   ;      get_dirs_sizes.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      orbit2date when processing the first available ORBIT.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2date when processing the last available ORBIT.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   get_dirs_sizes.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function currently reports on the first and last
   ;      MISR files of the specified MODE found in each of the
   ;      subdirectories matching path_pattern. It does not verify the
   ;      availability of all 9 L1B2 files per ORBIT, or of the associated
   ;      L2 Land Surface and the Geometric Parameters files, which are
   ;      also required by the MISR-HR processing system.
   ;
   ;  *   NOTE 2: In general, there may not be continuous coverage between
   ;      the first and last reported dates: MISR L1B2 GM files may be
   ;      occasionally missing for technical reasons, and L1B2 LM files
   ;      may only be acquired occasionally on a given site, or on
   ;      different sites on the same ORBIT at different dates.
   ;
   ;  *   NOTE 3: For generic purposes, and in particular to save this
   ;      information in a local file, use the program avail_l1b2.pro
   ;      instead of this function.
   ;
   ;  EXAMPLES:
   ;
   ;      [On MicMac2:]
   ;
   ;      IDL> root_dirs = set_root_dirs()
   ;      IDL> misr_mode = 'GM'
   ;      IDL> dir_patt = root_dirs[1] + 'P*/L1_' + misr_mode + '/'
   ;      IDL> rc = avail_l1b2_data(misr_mode, dir_patt, $
   ;         misr_l1b2_data, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', strstr(rc), ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> help, /STRUCTURE, misr_l1b2_data
   ;      ** Structure <3898cc08>, 7 tags, length=368, data length=360, refs=1:
   ;         TITLE           STRING    'MISR L1B2 GM data availability'
   ;         NUMDIRS         LONG                 5
   ;         DIRNAMES        STRING    Array[5]
   ;         DIRSIZES        STRING    Array[5]
   ;         NUMFILES        LONG      Array[5]
   ;         INIDATE         STRING    Array[5]
   ;         FINDATE         STRING    Array[5]
   ;      IDL> PRINT, misr_l1b2_data.DIRNAMES
   ;      /Volumes/MISR_Data3/P168/L1_GM/
   ;      /Volumes/MISR_Data3/P169/L1_GM/
   ;      /Volumes/MISR_Data3/P170/L1_GM/
   ;      /Volumes/MISR_Data3/P171/L1_GM/
   ;      /Volumes/MISR_Data3/P176/L1_GM/
   ;      IDL> PRINT, misr_l1b2_data.DIRSIZES
   ;      615G 560G 558G 546G 542G
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–24: Version 0.9 — Initial release, under the name
   ;      avail_l1b2_gm_data.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–04: Version 1.1 — Merge this function with its twin
   ;      avail_l1b2_lm_data.pro and change the name to avail_l1b2.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;Sec-Cod

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   ;  Initialize the output positional parameter(s):
   misr_l1b2_data = {}

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, path_pattern, misr_l1b2_data.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'path_pattern' is not of type STRING:
      IF (is_string(path_pattern) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument path_pattern is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'path_pattern' is not a directory (which can contain wildcard characters
   ;  but not be an array of directories):
      rc = is_dir(path_pattern, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc EQ 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Directory ' + path_pattern + ' is not a directory or is ' + $
            'not accessible.'
         RETURN, error_code
      ENDIF
      IF (rc EQ -1) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Get the list of directories containing MISR data and their sizes:
   rc = get_dirs_sizes(path_pattern, n_dirs, dirs_names, dirs_sizes, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 150
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Define the arrays that will contain some of the results:
   n_files = LONARR(n_dirs)
   date_1 = STRARR(n_dirs)
   date_2 = STRARR(n_dirs)

   FOR j = 0, n_dirs - 1 DO BEGIN

   ;  Document the dates of the first and last available L1B2 acquisitions
   ;  in each directory:
      files_patt = dirs_names[j] + 'MISR_AM1_GRP_TERRAIN_' + misr_mode + '_*'
      files = FILE_SEARCH(files_patt, COUNT = nf)
      n_files[j] = nf

      fst = FILE_BASENAME(files[0])
      parts = STRSPLIT(fst, '_', COUNT = nparts, /EXTRACT)
      mis_orbit_str1 = parts[6]
      misr_orbit_1 = LONG(STRMID(mis_orbit_str1, 1))
      date_1[j] = orbit2date(misr_orbit_1, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND ((date_1[j] EQ '') OR (excpt_cond NE ''))) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

      lst = FILE_BASENAME(files[n_files[j] - 1])
      parts = STRSPLIT(lst, '_', COUNT = nparts, /EXTRACT)
      mis_orbit_str2 = parts[6]
      misr_orbit_2 = LONG(STRMID(mis_orbit_str2, 1))
      date_2[j] = orbit2date(misr_orbit_2, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND ((date_2[j] EQ '') OR (excpt_cond NE ''))) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDFOR

   ;  Define the output structure 'misr_l1b2_data' to hold the results:
   title = 'MISR L1B2 ' + misr_mode + ' data availability'
   misr_l1b2_data = CREATE_STRUCT('Title', title)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'NumDirs', n_dirs)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'DirNames', dirs_names)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'DirSizes', dirs_sizes)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'NumFiles', n_files)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'IniDate', date_1)
   misr_l1b2_data = CREATE_STRUCT(misr_l1b2_data, 'FinDate', date_2)

   RETURN, return_code

END
