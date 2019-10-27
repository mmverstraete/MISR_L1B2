FUNCTION find_miss_l1b2gm_files, $
   misr_path, $
   n_miss_l1b2gm_files, $
   FROM_DATE = from_date, $
   UNTIL_DATE = until_date, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function inspects the available MISR L1B2 Global Mode
   ;  files for the specified PATH, and reports on missing files within
   ;  the specified or default period.
   ;
   ;  ALGORITHM: This function relies on the MISR Toolkit to generate a
   ;  list of L1B2 GM files for the specified PATH and the default (or
   ;  optionally specified VERSION) that occur between the from_date and
   ;  the until_date dates, inclusive. It checks whether these files exist
   ;  and are readable in the default or specified location, and reports
   ;  on the number of missing files. If the optional input keyword
   ;  parameter log_it is set, it saves a log file containing the names of
   ;  the missing files, in the default or specified folder.
   ;
   ;  SYNTAX:
   ;  rc = find_miss_l1b2gm_files(misr_path, n_miss_l1b2gm_files, $
   ;  FROM_DATE = from_date, UNTIL_DATE = until_date, n_miss_l1b2gm_files $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;  LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   n_miss_l1b2gm_files {LONG} [O]: The number of missing MISR
   ;      Global Mode L1B2 files.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2GM_FOLDER = l1b2gm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2GM_VERSION = l1b2gm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the processing log.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output positional parameter
   ;      n_miss_l1b2gm_files reports on the number of missing files in
   ;      the designated or default folder, between the specified dates. A
   ;      log file is saved if the input keyword parameter LOG_IT is set.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter n_miss_l1b2gm_files
   ;      may be undefined, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Warning 98: The computer has not been recognized by the function
   ;      get_host_info.pro.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      chk_ymddate.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      chk_ymddate.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters l1b2gm_folder, log_folder
   ;      is not specified.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      set_l1b2gm_folder.pro.
   ;
   ;  *   Error 400: The output folder log_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      find_orbits_paths_dates.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   chk_ymddate.pro
   ;
   ;  *   find_orbits_paths_dates.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_file.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_l1b2gm_folder.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function ONLY works for MISR L1B2 Global Mode data,
   ;      because Local Mode acquisitions are generally temporary and
   ;      result in files with different, non-standard filenames.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> from_date = '2000-02-24'
   ;      IDL> until_date = '2018-12-31'
   ;      IDL> l1b2gm_folder = ''
   ;      IDL> l1b2gm_version = ''
   ;      IDL> log_it = 1
   ;      IDL> log_folder = ''
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = find_miss_l1b2gm_files(misr_path, $
   ;         n_miss_l1b2gm_files, FROM_DATE = from_date, $
   ;         UNTIL_DATE = until_date, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, $
   ;         L1B2GM_VERSION = l1b2gm_version, $
   ;         LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;      The log file has been saved in ~/MISR_HR/Outcomes/P168/GM/Missing_L1B2GM_Orbits_2019-10-27.txt.
   ;      Number of missing files for Path 168 between
   ;         2000-02-24T00:00:00Z and 2018-12-31T23:59:59Z is 63.
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel Verstraete, Linda Hunt and Veljko M. Jovanovic (2019)
   ;      _Improving the usability of the MISR L1B2 Georectified Radiance
   ;      Product (2000–present) in land surface applications_,
   ;      Earth System Science Data, Vol. xxx, p. yy–yy, available from
   ;      https://www.earth-syst-sci-data.net/essd-2019-zz/ (DOI:
   ;      10.5194/zzz).
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–05–10: Version 1.0 — Initial public release.
   ;
   ;  *   2019–05–12: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–06–11: Version 2.01 — Update the code to rely on the IDL
   ;      function FILE_TEST rather than is_writable.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      VERBOSE and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–10–26: Version 2.1.1 — Improve the screen output when
   ;      VERBOSE is set.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
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
   ;      be included in its entirety in all copies or substantial
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
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   ;  Initialize the output positional parameter(s):
   n_miss_l1b2gm_files = 0L

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, n_miss_l1b2gm_files.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   misr_cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 98
      excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
   ENDIF

   ;  Set the default folders and version identifiers of the MISR and
   ;  MISR-HR files on this computer, and return to the calling routine if
   ;  there is an internal error, but not if the computer is unrecognized, as
   ;  root addresses can be overridden by input keyword parameters:
   rc_roots = set_roots_vers(root_dirs, versions, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc_roots GE 100)) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (~KEYWORD_SET(l1b2gm_version)) THEN l1b2gm_version = versions[2]

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pm_str = misr_path_str + PATH_SEP() + 'GM'

   ;  Set the date range to inspect:
   IF (KEYWORD_SET(from_date)) THEN BEGIN
      rc = chk_ymddate(from_date, year, month, day, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE from_date = '2000-02-24'

   IF (KEYWORD_SET(until_date)) THEN BEGIN
      rc = chk_ymddate(until_date, year, month, day, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE until_date = date

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF ((l1b2 AND (~KEYWORD_SET(l1b2gm_folder))) OR $
         (log_it AND (~KEYWORD_SET(log_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + '. And at least one of the optional input ' + $
            'keyword parameters l1b2gm_folder, log_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing the MISR L1B2 files:
   rc = set_l1b2gm_folder('GM', misr_path, l1b2gm_fpath, n_l1b2gm_files, $
      L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
      VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the list of expected MISR files between the from_date and the
   ;  until_date for the specified Path, and set the number of Orbits
   ;  concerned between the defaults or specified dates:
   rc = find_orbits_paths_dates(misr_path, misr_path, $
      from_date, until_date, misr_orbits, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND rc NE 0) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_orbits = misr_orbits.misr_path_0_norbits
   orbits = misr_orbits.misr_path_0_orbits

   IF (log_it) THEN BEGIN

   ;  Set the directory address of the folder containing the log file:
      IF (KEYWORD_SET(log_folder)) THEN BEGIN
         rc = force_path_sep(log_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         log_fpath = log_folder
      ENDIF ELSE BEGIN
         log_fpath = root_dirs[3] + pm_str + PATH_SEP()
      ENDELSE

   ;  Check that the output directory 'log_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(log_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The output folder log_fpath is unwritable.'
         RETURN, error_code
      ENDIF

   ;  Generate the specification of the log file:
      log_fname = 'Missing_L1B2GM_Orbits_' + date + '.txt'
      log_fspec = log_fpath + log_fname

   ;  Open and initiate the output log file:
      fmt1 = '(A30, A)'

      OPENW, log_unit, log_fspec, /GET_LUN
      PRINTF, log_unit, 'File name: ', FILE_BASENAME(log_fspec), $
         FORMAT = fmt1
      PRINTF, log_unit, 'Folder name: ', FILE_DIRNAME(log_fspec, $
         /MARK_DIRECTORY), FORMAT = fmt1
      PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Content: ', 'Information on missing L1B2 GM files', $
         FORMAT = fmt1
      PRINTF, log_unit, 'L1B2 GM path: ', l1b2gm_fpath, FORMAT = fmt1
      PRINTF, log_unit
      PRINTF, log_unit, 'MISR Mode: ', 'GM', FORMAT = fmt1
      PRINTF, log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
      PRINTF, log_unit, 'From: ', from_date, FORMAT = fmt1
      PRINTF, log_unit, 'Until: ', until_date, FORMAT = fmt1
      PRINTF, log_unit, '# Orbits accomplished: ', strstr(n_orbits), $
         FORMAT = fmt1
      PRINTF, log_unit
      PRINTF, log_unit, 'Missing files:', '', FORMAT = fmt1
      PRINTF, log_unit
   ENDIF

   ;  Loop over the Orbits:
   FOR n_orbit = 0, n_orbits - 1 DO BEGIN
      orbit = orbits[n_orbit]
      product = 'GRP_TERRAIN_GM'

   ;  Loop over the Cameras:
      FOR cam = 0, n_cams - 1 DO BEGIN
         camera = misr_cams[cam]
         status = MTK_MAKE_FILENAME(l1b2gm_fpath, product, camera, $
            misr_path, orbit, l1b2gm_version, l1b2gm_filename)

   ;  Assess and report whether that file exists and is readable:
         res = is_readable_file(l1b2gm_filename)
         IF (res NE 1) THEN BEGIN
            n_miss_l1b2gm_files++
            IF (log_it) THEN PRINTF, log_unit, l1b2gm_filename
         ENDIF
      ENDFOR
   ENDFOR

   IF (log_it) THEN BEGIN
      PRINTF, log_unit
      PRINTF, log_unit, 'Number of missing files: ', n_miss_l1b2gm_files, $
         FORMAT = fmt1
      PRINTF, log_unit
      CLOSE, log_unit
      FREE_LUN, log_unit
   ENDIF

   IF (verbose GT 0) THEN BEGIN
      IF (log_it) THEN PRINT, 'The log file has been saved in ' + $
         log_fspec + '.'
      PRINT, 'Number of missing files for Path ' + strstr(misr_path) + $
         ' between ' + strstr(from_date) + ' and ' + strstr(until_date) + $
         ' is ' + strstr(n_miss_l1b2gm_files) + '.'
   ENDIF
   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
