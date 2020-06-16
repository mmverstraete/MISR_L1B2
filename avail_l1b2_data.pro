FUNCTION avail_l1b2_data, $
   misr_mode, $
   path_pattern, $
   misr_l1b2_data, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports on the availability of MISR L1B2
   ;  Global or Local Mode data files in the subdirectories matching the
   ;  IDL regular expression path_pattern.
   ;
   ;  ALGORITHM: This function searches the directory addresses matching
   ;  the pattern path_pattern for MISR L1B2 files of the specified MODE,
   ;  and stores information on their names, sizes and range of temporal
   ;  coverage in the output positional parameter structure
   ;  misr_l1b2_data.
   ;
   ;  SYNTAX: rc = avail_l1b2_data(misr_mode, path_pattern, $
   ;  misr_l1b2_data, VERBOSE = verbose, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
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
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) reporting progress on the console: 1 only
   ;      reports exiting the routine; 2 reports entering and exiting the
   ;      routine, as well as key milestones; 3 reports entering and
   ;      exiting the routine, and provides detailed information on the
   ;      intermediary results.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
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
   ;  *   Error 200: An exception condition occurred in function
   ;      get_dirs_sizes.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2date when processing the first available ORBIT.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      orbit2date when processing the last available ORBIT.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   get_dirs_sizes.pro
   ;
   ;  *   is_numeric.pro
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
   ;  *   NOTE 4: No exception conditions are raised if no MISR L1B2 data
   ;      of the specified MODE are found on this computer; a warning
   ;      message is printed on the console only if the input keyword
   ;      parameter VERBOSE is set to at least 1.
   ;
   ;  EXAMPLES:
   ;
   ;      [On MicMac2:]
   ;
   ;      IDL> rc = set_roots_vers(root_dirs, versions, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> misr_mode = 'GM'
   ;      IDL> dir_patt = root_dirs[1] + 'P*/L1_' + misr_mode + '/'
   ;      IDL> rc = avail_l1b2_data(misr_mode, dir_patt, $
   ;         misr_l1b2_data, /VERBOSE, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', strstr(rc), ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, misr_l1b2_data.DIRNAMES
   ;      /Volumes/MISR_Data0/P167/L1_GM/
   ;      /Volumes/MISR_Data0/P168/L1_GM/
   ;      /Volumes/MISR_Data0/P169/L1_GM/
   ;      /Volumes/MISR_Data0/P170/L1_GM/
   ;      /Volumes/MISR_Data0/P171/L1_GM/
   ;      /Volumes/MISR_Data0/P172/L1_GM/
   ;      /Volumes/MISR_Data0/P173/L1_GM/
   ;      IDL> PRINT, misr_l1b2_data.DIRSIZES
   ;      671G 682G 680G 677G 657G 672G 667G
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2019) Improving the usability of the MISR L1B2
   ;      Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data Discussions (ESSDD)_,
   ;      Vol. 2019, p. 1–31, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/ (DOI:
   ;      10.5194/essd-2019-210).
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2020) Multi-angle Imaging SpectroRadiometer (MISR)
   ;      L1B2 Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data (ESSD)_, Vol. 12,
   ;      p. 1321-1346, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/
   ;      (DOI: 10.5194/essd-12-1321-2020).
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
   ;
   ;  *   2018–-12–24: Version 1.6 — Update this routine to rely on the
   ;      new function
   ;      set_roots_vers.pro.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.01 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–06–11: Version 2.02 — Update the documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–10: Version 2.1.7 — Software version described in the
   ;      peer-reviewed paper published in \textit{ESSD} referenced above.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in their entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

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
   ENDIF

   ;  Get the list of directories containing MISR data and their sizes:
   rc = get_dirs_sizes(path_pattern, n_dirs, dirs_names, dirs_sizes, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine if no directories are found:
   IF (n_dirs EQ 0) THEN BEGIN
      misr_l1b2_data = {}
      IF (verbose GT 0) THEN PRINT, 'No MISR L1B2 ' + misr_mode + $
         ' data found on this computer.'
      RETURN, return_code
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
         error_code = 210
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
         error_code = 220
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

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
