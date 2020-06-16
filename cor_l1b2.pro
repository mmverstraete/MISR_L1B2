FUNCTION cor_l1b2, $
   misr_mode, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   L1B2_FOLDER = l1b2_folder, $
   L1B2_VERSION = l1b2_version, $
   MISR_SITE = misr_site, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   SAVE_IT = save_it, $
   SAVE_FOLDER = save_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function saves the results of the computation of the
   ;  cross-correlation statistics between the 36 data channels of the 9
   ;  MISR L1B2 Georectified Radiance Product (GRP) Terrain-Projected Top
   ;  of Atmosphere (ToA) files, in the specified MISR MODE, for a single
   ;  MISR PATH, ORBIT and BLOCK combination.
   ;
   ;  ALGORITHM: This function relies on the IDL function
   ;  cor_l1b2_block.pro to carry out the computations, and saves the
   ;  numerical results in an IDL SAVE file as well as in a plain text
   ;  file. If the input data are from GLOBAL MODE files, this function
   ;  also separately computes the correlations between the 12 high
   ;  spatial resolution BRF fields.
   ;
   ;  SYNTAX:
   ;  rc = cor_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  L1B2_FOLDER = l1b2_folder, L1B2_VERSION = l1b2_version, $
   ;  MISR_SITE = misr_site, LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR mode.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2_FOLDER = l1b2_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2_VERSION = l1b2_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   MISR_SITE = misr_site {STRING} [I] (Default value: None: The
   ;      official name of the Local Mode site.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the processing log.
   ;
   ;  *   SAVE_IT = save_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) saving the results in a savefile.
   ;
   ;  *   SAVE_FOLDER = save_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the savefile.
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
   ;      provided in the call. By default, this function generates and
   ;      saves 2 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_’ + [misr_mode] + ’/’:
   ;
   ;      -   1 plain text file containing the numerical results of the
   ;          correlation computations, named
   ;          corr_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_toabrf_
   ;          [acquisition-date]_[MISR-Version]_[creation-date].txt.
   ;
   ;      -   1 IDL SAVE file containing the numerical results of the
   ;          correlation computations, named
   ;          corr_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_toabrf_
   ;          [acquisition-date]_[MISR-Version]_[creation-date].sav.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output files may be inexistent, incomplete or
   ;      useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Warning 98: The computer has not been recognized by the function
   ;      get_host_info.pro.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_mode is invalid.
   ;
   ;  *   Error 120: Input argument misr_path is invalid.
   ;
   ;  *   Error 130: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 132: The input positional parameter misr_orbit is
   ;      inconsistent with the input positional parameter misr_path.
   ;
   ;  *   Error 134: An exception condition occurred in is_frompath.pro.
   ;
   ;  *   Error 136: Unexpected return code received from is_frompath.pro.
   ;
   ;  *   Error 140: Input argument misr_block is invalid.
   ;
   ;  *   Error 150: Attempt to process Local Mode data while misr_site is
   ;      an empty string.
   ;
   ;  *   Error 160: Attempt to process Local Mode data while misr_site is
   ;      undefined.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: Unrecognized misr_mode in a CASE statement.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 240: An exception condition occurred in function
   ;      orbit2date.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters l1b2_folder, log_folder,
   ;      save_folder is not specified.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      find_l1b2gm_files.pro.
   ;
   ;  *   Error 310: An exception condition occurred in function
   ;      find_l1b2lm_files.pro
   ;
   ;  *   Error 400: The directory log_fpath is unwritable.
   ;
   ;  *   Error 410: The directory save_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      cor_l1b2_block.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   cor_l1b2_block.pro
   ;
   ;  *   find_l1b2gm_files.pro
   ;
   ;  *   find_l1b2lm_files.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   is_frompath.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = cor_l1b2('GM', 168, 68050, 110, /LOG_IT, $
   ;         /SAVE_IT, VERBOSE = 1, /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;      generates a log file and a save file in the default folder.
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
   ;
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
   ;  *   2017–03–15: Version 0.8 — Initial release under the name
   ;      cor_l1b2.
   ;
   ;  *   2017–07–21: Version 0.9 — Use current version of the correlation
   ;      routines; update documentation; change the function name to
   ;      cor_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–05–02: Version 1.2 — Merge this function with its twin
   ;      cor_l1b2_lm.pro and change the name to cor_l1b2.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–05: Version 1.6 — Update this routine to rely on the new
   ;      function
   ;      get_host_info.pro and the updated version of the function
   ;      set_root_dirs.pro.
   ;
   ;  *   2019–01–24: Version 1.7 — Add the input keyword parameters
   ;      L1B2_FOLDER,
   ;      L1B2_VERSION, LOG_IT, LOG_FOLDER, SAVE_IT, SAVE_FOLDER, VERBOSE.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–05–02: Version 2.11 — Bug fix: Encapsulate folder and file
   ;      creation in IF statements.
   ;
   ;  *   2019–06–11: Version 2.12 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–12–19: Version 2.1.1 — Bug fix (missing ENDIF statement).
   ;
   ;  *   2020–03–24: Version 2.1.2 — Edit the code to (1) add the
   ;      optional keyword parameter MISR_SITE to allow processing of
   ;      Local Mode data and update the code to save the appropriate
   ;      statistics in that case, (2) implement exception conditions 150
   ;      and 160 to check the existence of that new keyword, (3) enable
   ;      all keywords in the call to find_l1b2gm_files, (4) save all
   ;      output files in a more appropriate default folder, and (5)
   ;      update the documentation.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–10: Version 2.1.7 — Software version described in the
   ;      peer-reviewed paper published in _ESSD_ referenced above.
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
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (KEYWORD_SET(save_it)) THEN save_it = 1 ELSE save_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, misr_orbit, ' + $
            'misr_block.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is inconsistent with the input
   ;  positional parameter 'misr_path':
      res = is_frompath(misr_path, misr_orbit, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (res NE 1) THEN BEGIN
         CASE 1 OF
            (res EQ 0): BEGIN
               error_code = 132
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input positional parameter ' + $
                  'misr_orbit is inconsistent with the input positional ' + $
                  'parameter misr_path.'
               RETURN, error_code
            END
            (res EQ -1): BEGIN
               error_code = 134
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 136
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Unexpected return code ' + strstr(res) + $
                  ' from is_frompath.pro.'
               RETURN, error_code
            END
         ENDCASE
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional
   ;  keyword parameter MISR_SITE is empty or undefined while processing
   ;  Local Mode data:
      IF (misr_mode EQ 'LM') THEN BEGIN
         IF (is_defined(misr_site)) THEN BEGIN
            IF (misr_site EQ '') THEN BEGIN
               error_code = 150
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Attempt to process Local Mode data ' + $
                  "while misr_site = ''."
               RETURN, error_code
            ENDIF
         ENDIF ELSE BEGIN
            error_code = 160
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
               rout_name + ': Attempt to process Local Mode data ' + $
               'while misr_site is undefined.'
            RETURN, error_code
         ENDELSE
      ENDIF
   ENDIF

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
   IF (~KEYWORD_SET(l1b2_version)) THEN BEGIN
      CASE misr_mode OF
         'GM': l1b2_version = versions[2]
         'LM': l1b2_version = versions[3]
         ELSE: BEGIN
            error_code = 200
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Unrecognized misr_mode.'
            RETURN, error_code
         END
      ENDCASE
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   pob_str = strcat([misr_path_str, misr_orbit_str, misr_block_str], '-')
   mpob_str = strcat([misr_mode, pob_str], '-')

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 240
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(l1b2_folder) OR $
         (log_it AND (~KEYWORD_SET(log_folder))) OR $
         (save_it AND (~KEYWORD_SET(save_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And at least one of the optional input ' + $
            'keyword parameters l1b2_folder, log_folder, save_folder ' + $
            'is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Locate the 9 MISR L1B2 input files corresponding to the specified Mode, ;  Path and Orbit numbers:
   IF (misr_mode EQ 'GM') THEN BEGIN
      rc = find_l1b2gm_files(misr_path, misr_orbit, l1b2_files, $
         L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE BEGIN
      rc = find_l1b2lm_files(misr_site, misr_path, misr_orbit, l1b2_files, $
         L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDELSE

   IF (log_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output log file
   ;  if it has not been set previously:
      IF (KEYWORD_SET(log_folder)) THEN BEGIN
         rc = force_path_sep(log_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         log_fpath = log_folder
      ENDIF ELSE BEGIN
         log_fpath = root_dirs[3] + pob_str + PATH_SEP() + misr_mode + $
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Correlations' + PATH_SEP()
      ENDELSE

   ;  Check that the output directory 'log_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(log_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory log_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   IF (save_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output save file
   ;  if it has not been set previously:
      IF (KEYWORD_SET(save_folder)) THEN BEGIN
         rc = force_path_sep(save_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         save_fpath = save_folder
      ENDIF ELSE BEGIN
         save_fpath = root_dirs[3] + pob_str + PATH_SEP() + misr_mode + $
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Correlations' + PATH_SEP()
      ENDELSE

   ;  Check that the output directory 'save_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(save_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 410
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory save_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Compute the correlation statistics:
   rc = cor_l1b2_block(l1b2_files, misr_mode, misr_path, misr_orbit, $
      misr_block, stats_lr, stats_hr, VERBOSE = verbose, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Save the results in an IDL save file, if requested. For GM input data,
   ;  statistics are generated separately for low and high resolution channels;
   ;  for LM data, all data channels are available at the full spatial
   ;  resolution but the results from 'cor_l1b2_block.pro' are still reported
   ;  in 'stats_lr':
   IF (save_it) THEN BEGIN
      save_fname = 'Save_L1B2_corr_' + mpob_str + '_' + $
         acquis_date + '_' + date + '.sav'
      save_fspec = save_fpath + save_fname

      IF (misr_mode EQ 'GM') THEN BEGIN
         descr = 'Cross-correlations between the 36 data channels ' + $
            'of MISR L1B2 Global Mode (low and high res).'
         SAVE, stats_lr, stats_hr, DESCRIPTION = descr, FILENAME = save_fspec
      ENDIF ELSE BEGIN
         descr = 'Cross-correlations between the 36 data channels ' + $
            'of MISR L1B2 Local Mode (high res).'
         SAVE, stats_lr, DESCRIPTION = descr, FILENAME = save_fspec
      ENDELSE
   ENDIF

   ;  Save the log file, if requested:
   IF (log_it) THEN BEGIN
      log_fname = 'Log_L1B2_corr_' + mpob_str + '_' + $
         acquis_date + '_' + date + '.txt'
      log_fspec = log_fpath + log_fname

      fmt1 = '(A30, A)'
      fmt2 = '(A30, A)'

   ;  Open the log file and save the statistical information:
      OPENW, log_unit, log_fspec, /GET_LUN
      PRINTF, log_unit, "File name: ", "'" + log_fname + "'", FORMAT = fmt1
      PRINTF, log_unit, "Folder name: ", $
         "root_dirs[3] + '" + log_fpath + "'", FORMAT = fmt1
      PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, log_unit, 'Saved on: ', date, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Date of MISR acquisition: ', acquis_date, $
         FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Content: ', 'Statistical results on', FORMAT = fmt1
      PRINTF, log_unit, '', '- the 630 (36x35/2) cross-correlations between', $
         FORMAT = fmt1
      PRINTF, log_unit, '', '  the 36 low spatial resolution data channels', $
         FORMAT = fmt1
      PRINTF, log_unit, '', '- the 66 (12x11/2) cross-correlations between', $
         FORMAT = fmt1
      PRINTF, log_unit, '', '  the 12 high spatial resolution data channels', $
         FORMAT = fmt1
      PRINTF, log_unit, '', '  of MISR L1B2 GRP Terrain-Projected ToA GM ' + $
         'BRF for', FORMAT = fmt1
      PRINTF, log_unit, '', '  ' + mpob_str, FORMAT = fmt1
      PRINTF, log_unit

   ;  For GM files, save the correlation statistics for the low spatial
   ;  resolution data channels:
      IF (misr_mode EQ 'GM') THEN BEGIN
         PRINTF, log_unit
         PRINTF, log_unit, 'GM low spatial resolution correlation results:'
         PRINTF, log_unit
         n_exp = N_ELEMENTS(stats_lr)
         FOR i = 0, n_exp - 1 DO BEGIN
            PRINTF, log_unit, 'Experiment: ', $
               strstr(stats_lr[i].experiment), FORMAT = fmt2
            PRINTF, log_unit, 'array_1_id: ', $
               strstr(stats_lr[i].array_1_id), FORMAT = fmt2
            PRINTF, log_unit, 'array_2_id: ', $
               strstr(stats_lr[i].array_2_id), FORMAT = fmt2
            PRINTF, log_unit, 'N_points: ', $
               strstr(stats_lr[i].N_points), FORMAT = fmt2
            PRINTF, log_unit, 'RMSD: ', $
               strstr(stats_lr[i].RMSD), FORMAT = fmt2
            PRINTF, log_unit, 'Pearson_cc: ', $
               strstr(stats_lr[i].Pearson_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_cc: ', $
               strstr(stats_lr[i].Spearman_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_sig: ', $
               strstr(stats_lr[i].Spearman_sig), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_D: ', $
               strstr(stats_lr[i].Spearman_D), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_PROBD: ', $
               strstr(stats_lr[i].Spearman_PROBD), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_ZD: ', $
               strstr(stats_lr[i].Spearman_ZD), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_1: ', $
               strstr(stats_lr[i].Linear_fit_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_1: ', $
               strstr(stats_lr[i].Linfit_a_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_1: ', $
               strstr(stats_lr[i].Linfit_b_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_1: ', $
               strstr(stats_lr[i].Linfit_CHISQR_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_1: ', $
               strstr(stats_lr[i].Linfit_PROB_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_2: ', $
               strstr(stats_lr[i].Linear_fit_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_2: ', $
               strstr(stats_lr[i].Linfit_a_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_2: ', $
               strstr(stats_lr[i].Linfit_b_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_2: ', $
               strstr(stats_lr[i].Linfit_CHISQR_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_2: ', $
               strstr(stats_lr[i].Linfit_PROB_2), FORMAT = fmt2
            PRINTF, log_unit
         ENDFOR

   ;  Save the correlation statistics for the high spatial resolution data
   ;  channels:
         PRINTF, log_unit
         PRINTF, log_unit, 'GM high spatial resolution results:'
         PRINTF, log_unit
         n_exp = N_ELEMENTS(stats_hr)
         FOR i = 0, n_exp - 1 DO BEGIN
            PRINTF, log_unit, 'Experiment: ', $
               strstr(stats_hr[i].experiment), FORMAT = fmt2
            PRINTF, log_unit, 'array_1_id: ', $
               strstr(stats_hr[i].array_1_id), FORMAT = fmt2
            PRINTF, log_unit, 'array_2_id: ', $
               strstr(stats_hr[i].array_2_id), FORMAT = fmt2
            PRINTF, log_unit, 'N_points: ', $
               strstr(stats_hr[i].N_points), FORMAT = fmt2
            PRINTF, log_unit, 'RMSD: ', $
               strstr(stats_hr[i].RMSD), FORMAT = fmt2
            PRINTF, log_unit, 'Pearson_cc: ', $
               strstr(stats_hr[i].Pearson_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_cc: ', $
               strstr(stats_hr[i].Spearman_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_sig: ', $
               strstr(stats_hr[i].Spearman_sig), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_D: ', $
               strstr(stats_hr[i].Spearman_D), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_PROBD: ', $
               strstr(stats_hr[i].Spearman_PROBD), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_ZD: ', $
               strstr(stats_hr[i].Spearman_ZD), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_1: ', $
               strstr(stats_hr[i].Linear_fit_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_1: ', $
               strstr(stats_hr[i].Linfit_a_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_1: ', $
               strstr(stats_hr[i].Linfit_b_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_1: ', $
               strstr(stats_hr[i].Linfit_CHISQR_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_1: ', $
               strstr(stats_hr[i].Linfit_PROB_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_2: ', $
               strstr(stats_hr[i].Linear_fit_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_2: ', $
               strstr(stats_hr[i].Linfit_a_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_2: ', $
               strstr(stats_hr[i].Linfit_b_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_2: ', $
               strstr(stats_hr[i].Linfit_CHISQR_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_2: ', $
               strstr(stats_hr[i].Linfit_PROB_2), FORMAT = fmt2
            PRINTF, log_unit
         ENDFOR
      ENDIF ELSE BEGIN
         PRINTF, log_unit
         PRINTF, log_unit, 'LM high spatial resolution results:'
         PRINTF, log_unit
         n_exp = N_ELEMENTS(stats_hr)
         fmt2 = '(A32, A)'
         FOR i = 0, n_exp - 1 DO BEGIN
            PRINTF, log_unit, 'Experiment: ', $
               strstr(stats_hr[i].experiment), FORMAT = fmt2
            PRINTF, log_unit, 'array_1_id: ', $
               strstr(stats_hr[i].array_1_id), FORMAT = fmt2
            PRINTF, log_unit, 'array_2_id: ', $
               strstr(stats_hr[i].array_2_id), FORMAT = fmt2
            PRINTF, log_unit, 'N_points: ', $
               strstr(stats_hr[i].N_points), FORMAT = fmt2
            PRINTF, log_unit, 'RMSD: ', $
               strstr(stats_hr[i].RMSD), FORMAT = fmt2
            PRINTF, log_unit, 'Pearson_cc: ', $
               strstr(stats_hr[i].Pearson_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_cc: ', $
               strstr(stats_hr[i].Spearman_cc), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_sig: ', $
               strstr(stats_hr[i].Spearman_sig), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_D: ', $
               strstr(stats_hr[i].Spearman_D), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_PROBD: ', $
               strstr(stats_hr[i].Spearman_PROBD), FORMAT = fmt2
            PRINTF, log_unit, 'Spearman_ZD: ', $
               strstr(stats_hr[i].Spearman_ZD), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_1: ', $
               strstr(stats_hr[i].Linear_fit_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_1: ', $
               strstr(stats_hr[i].Linfit_a_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_1: ', $
               strstr(stats_hr[i].Linfit_b_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_1: ', $
               strstr(stats_hr[i].Linfit_CHISQR_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_1: ', $
               strstr(stats_hr[i].Linfit_PROB_1), FORMAT = fmt2
            PRINTF, log_unit, 'Linear_fit_2: ', $
               strstr(stats_hr[i].Linear_fit_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_a_2: ', $
               strstr(stats_hr[i].Linfit_a_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_b_2: ', $
               strstr(stats_hr[i].Linfit_b_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_CHISQR_2: ', $
               strstr(stats_hr[i].Linfit_CHISQR_2), FORMAT = fmt2
            PRINTF, log_unit, 'Linfit_PROB_2: ', $
               strstr(stats_hr[i].Linfit_PROB_2), FORMAT = fmt2
            PRINTF, log_unit
         ENDFOR
      ENDELSE

      IF (log_it) THEN BEGIN
         FREE_LUN, log_unit
         CLOSE, log_unit
      ENDIF

      IF (log_it AND verbose GT 0) THEN BEGIN
         PRINT, 'The log file'
         PRINT, '   ' + log_fname
         PRINT, 'has been written in the folder'
         PRINT, '   ' + log_fpath
      ENDIF

      IF (save_it AND verbose GT 0) THEN BEGIN
         PRINT, 'The numerical results have been written in the file'
         PRINT, '   ' + save_fname
         PRINT, 'located in folder'
         PRINT, '   ' + save_fpath
      ENDIF
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
