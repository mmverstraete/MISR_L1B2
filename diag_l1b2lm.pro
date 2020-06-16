FUNCTION diag_l1b2lm, $
   misr_site, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   L1B2LM_FOLDER = l1b2lm_folder, $
   L1B2LM_VERSION = l1b2lm_version, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   SAVE_IT = save_it, $
   SAVE_FOLDER = save_folder, $
   HIST_IT = hist_it, $
   HIST_FOLDER = hist_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function collects metadata and basic statistics about
   ;  the contents of a single MISR BLOCK within each of the 9 MISR L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Radiance files of the specified Local Mode (LM)
   ;  site, MISR PATH, ORBIT, and BLOCK, and saves these results into 9
   ;  text files and 9 corresponding IDL SAVE files. If the input keyword
   ;  parameter hist_it is set, this function generates histograms of the
   ;  ToA BRF values found in each spectral data channel and saves them in
   ;  the output folder specified by the keyword hist_folder, if provided,
   ;  or the default otherwise.
   ;
   ;  ALGORITHM: This function relies on the function diag_l1b2_block_cam
   ;  to retrieve the desired information about each camera file for the
   ;  specified MISR PATH, ORBIT, and BLOCK, and saves the 18 .txt and
   ;  .sav output files.
   ;
   ;  SYNTAX:
   ;  rc = diag_l1b2lm(misr_site, misr_path, misr_orbit, misr_block, $
   ;  L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
   ;  SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
   ;  HIST_IT = hist_it, HIST_FOLDER = hist_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_site {STRING} [I]: The selected MISR LM Site.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2LM_FOLDER = l1b2lm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2LM_VERSION = l1b2lm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   SAVE_IT = save_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) saving the results in a savefile.
   ;
   ;  *   SAVE_FOLDER = save_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the savefile.
   ;
   ;  *   HIST_IT = hist_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating histograms of the numerical results.
   ;
   ;  *   HIST_FOLDER = hist_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the histograms.
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
   ;      provided in the call. This function saves 18 output files in the
   ;      folder
   ;      root_dirs[2] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_[misr_mode]/’:
   ;
   ;      -   9 plain text output files containing diagnostic information
   ;          for each camera, named
   ;          diag_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_
   ;          [YYYY-MM-DD]_[MISR-Version]_[creation-date].txt.
   ;
   ;      -   9 IDL SAVE output files containing diagnostic information
   ;          for each camera, named
   ;          diag_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_
   ;          [YYYY-MM-DD]_[MISR-Version]_[creation-date].sav.
   ;
   ;      In addition, if the optional input keyword parameter HISTOGRAMS
   ;      is set in the call, the function diag_l1b2_block_cam.pro called
   ;      by this routine will also generate
   ;
   ;      -   36 histograms of the ToA BRF values found in these data
   ;          channels, named
   ;          Hist_L1B2_diag_ + [mpob_str] + ’-’ + [misr_camera] + ’-’ + $
   ;          [misr_band] + ’_’ + [acquis_date] + ’_’ + [date] + ’.png’
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
   ;  *   Error 110: Input argument misr_path is invalid.
   ;
   ;  *   Error 120: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 122: The input positional parameter misr_orbit is
   ;      inconsistent with the input positional parameter misr_path.
   ;
   ;  *   Error 124: An exception condition occurred in is_frompath.pro.
   ;
   ;  *   Error 126: Unexpected return code received from is_frompath.pro.
   ;
   ;  *   Error 130: Input argument misr_block is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      orbit2date.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters l1b2gm_folder, log_folder,
   ;      save_folder, hist_folder is not specified.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      find_l1b2lm_files.
   ;
   ;  *   Error 400: The directory log_fpath is unwritable.
   ;
   ;  *   Error 410: The directory save_fpath is unwritable.
   ;
   ;  *   Error 420: The directory hist_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      diag_l1b2_block_cam.pro.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_VERSION.
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
   ;  *   diag_l1b2_block_cam.pro
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
   ;  *   oom.pro
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
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input keyword parameters log_it, save_it, and
   ;      hist_it are provided to generate the desired outputs
   ;      selectively. Deselecting some of them (hist_it in particular)
   ;      may accelerate the processing, but if none of them are set, then
   ;      no output will be saved either.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = diag_l1b2lm('Skukuza', 168, 68050, 110, $
   ;         /LOG_IT, /SAVE_IT, /HIST_IT, $
   ;         /VERBOSE, /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;      results in the creation of 9 plain text files, 9 .sav files and
   ;      36 histograms in the folder root_dirs[3] + 'P168-O068050-B110/LM/'.
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
   ;  *   2017–07–14: Version 0.8 — Initial release under the name
   ;      diag_l1b2.pro.
   ;
   ;  *   2017–10–10: Version 0.9 — Changed the name of the function to
   ;      diag_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–04–08: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–06–01: Version 1.3 — Merge this function with its twin
   ;      diag_l1b2_lm.pro and change the name back to diag_l1b2.pro.
   ;
   ;  *   2018–06–07: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–06–17: Version 1.6 — Add MISR version number in the names
   ;      of the output files.
   ;
   ;  *   2018–07–07: Version 1.7 — Update this routine to rely on the new
   ;      function
   ;      get_host_info.pro and the updated version of the function
   ;      set_root_dirs.pro; and to take advantage of the updated version
   ;      of function diag_l1b2_block_cam.pro.
   ;
   ;  *   2019–01–23: Version 1.8 — Add the input keyword parameters
   ;      L1B2_FOLDER and L1B2_VERSION, LOG_IT and LOG_FOLDER, SAVE_IT and
   ;      SAVE_FOLDER, HIST_IT and HIST_FOLDER
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
   ;  *   2019–05–04: Version 2.13 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–06–11: Version 2.14 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–10: Version 2.15 — Create this function using the most
   ;      current version of diag_l1b2.pro as a template, add the
   ;      misr_site input argument.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2020–03–25: Version 2.1.1 — Edit the code to (1) pass the
   ;      optional keyword parameter VERBOSE to the function
   ;      diag_l1b2_block_cam.pro, (2) save all output files in a more
   ;      appropriate default folder, and (3) update the documentation.
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
   IF (KEYWORD_SET(sav_it)) THEN sav_it = 1 ELSE sav_it = 0
   IF (KEYWORD_SET(hist_it)) THEN hist_it = 1 ELSE hist_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_site, misr_path, misr_orbit, ' + $
            'misr_block.'
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

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
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
               error_code = 122
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input positional parameter ' + $
                  'misr_orbit is inconsistent with the input positional ' + $
                  'parameter misr_path.'
               RETURN, error_code
            END
            (res EQ -1): BEGIN
               error_code = 124
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 126
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
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
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
   IF (~KEYWORD_SET(l1b2lm_version)) THEN l1b2lm_version = versions[3]

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   misr_mode = 'LM'

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 220
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
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(l1b2lm_folder) OR $
         (log_it AND (~KEYWORD_SET(log_folder))) OR $
         (save_it AND (~KEYWORD_SET(save_folder))) OR $
         (hist_it AND (~KEYWORD_SET(hist_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And at least one of the optional input ' + $
            'keyword parameters l1b2lm_folder, log_folder, save_folder, ' + $
            'hist_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Get the file specifications of the 9 L1B2 files corresponding to the
   ;  inputs above:
   rc = find_l1b2lm_files(misr_site, misr_path, misr_orbit, l1b2lm_files, $
      L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_files = N_ELEMENTS(l1b2lm_files)

   IF (log_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output log file
   ;  if it has not been set previously:
      IF (KEYWORD_SET(log_folder)) THEN BEGIN
         rc = force_path_sep(log_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         log_fpath = log_folder
      ENDIF ELSE BEGIN
         log_fpath = root_dirs[3] + pob_str + PATH_SEP() + misr_mode + $
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Diagnostics' + PATH_SEP()
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
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Diagnostics' + PATH_SEP()
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

   IF (hist_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output hist file
   ;  if it has not been set previously:
      IF (KEYWORD_SET(hist_folder)) THEN BEGIN
         rc = force_path_sep(hist_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         hist_fpath = hist_folder
      ENDIF ELSE BEGIN
         hist_fpath = root_dirs[3] + pob_str + PATH_SEP() + misr_mode + $
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Diagnostics' + PATH_SEP()
      ENDELSE

   ;  Check that the output directory 'hist_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(hist_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 420
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory hist_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   i_cams = STRARR(n_files)
   i_vers = STRARR(n_files)
   log_fspecs = STRARR(n_files)
   fmt1 = '(A30, A)'

   FOR i = 0, n_files - 1 DO BEGIN

   ;  Get the camera name and the MISR version number from the input filename:
      parts = STRSPLIT(FILE_BASENAME(l1b2lm_files[i], '.hdf'), '_', $
         COUNT = n_parts, /EXTRACT)
      i_cams[i] = parts[7]
      status = MTK_FILE_VERSION(l1b2lm_files[0], misr_version)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 600
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Error message from MTK_FILE_VERSION: ' + $
            MTK_ERROR_MESSAGE(status)
         RETURN, error_code
      ENDIF
      i_vers[i] = misr_version

      IF (log_it) THEN BEGIN
         log_fname = 'Log_L1B2_diag_' + mpob_str + '-' + i_cams[i] + '_' + $
            acquis_date + '_' + date + '.txt'
         log_fspecs[i] = log_fpath + log_fname

   ;  Save the outcome in a separate diagnostic file for each camera:
         OPENW, log_unit, log_fspecs[i], /GET_LUN
         PRINTF, log_unit, 'File name: ', log_fname, FORMAT = fmt1
         PRINTF, log_unit, 'Folder name: ', log_fpath, FORMAT = fmt1
         PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
         PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
         PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
         PRINTF, log_unit

         PRINTF, log_unit, 'Content: ', 'Metadata for a single Block of ' + $
            'a single', FORMAT = fmt1
         PRINTF, log_unit, '', 'MISR L1B2 Terrain-projected Global Mode ' + $
            '(camera) file.', FORMAT = fmt1
         PRINTF, log_unit
         PRINTF, log_unit, 'MISR Mode: ', misr_mode, FORMAT = fmt1
         PRINTF, log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
         PRINTF, log_unit, 'MISR Orbit: ', strstr(misr_orbit), FORMAT = fmt1
         PRINTF, log_unit, 'MISR Block: ', strstr(misr_block), FORMAT = fmt1
         PRINTF, log_unit, 'MISR Camera: ', i_cams[i], FORMAT = fmt1
         PRINTF, log_unit, 'Date of MISR acquisition: ', acquis_date, $
            FORMAT = fmt1
         PRINTF, log_unit
      ENDIF

   ;  Gather the metadata for that file:
      rc = diag_l1b2_block_cam(l1b2lm_files[i], misr_block, meta_data, $
         HIST_IT = hist_it, HIST_FOLDER = hist_fpath, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 500
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': ' + excpt_cond
      ENDIF

   ;  Save the alphanumeric results contained in the structure 'meta_data' in
   ;  a camera-specific '.sav' file:
      IF (save_it) THEN BEGIN
         save_fname = 'Save_L1B2_diag_' + mpob_str + '-' + i_cams[i] + '_' + $
            acquis_date + '_' + date + '.sav'
         save_fspec = save_fpath + save_fname
         SAVE, meta_data, FILENAME = save_fspec
         IF (log_it) THEN BEGIN
            PRINTF, log_unit, 'File ' + FILE_BASENAME(save_fspec) + ' created.'
            PRINTF, log_unit
         ENDIF
         IF (verbose GT 0) THEN BEGIN
            PRINT, 'Saved ' + save_fspec
         ENDIF
      ENDIF

   ;  Print each diagnostic structure tag and its value in the diagnostic log
   ;  file:
      IF (log_it) THEN BEGIN
         ntags = N_TAGS(meta_data)
         tagnames = TAG_NAMES(meta_data)
         nd = oom(ntags, BASE = 10.0, DEBUG = debug, $
            EXCPT_COND = excpt_cond) + 1
         fmt2 = '(I' + strstr(nd) + ', A29, 3X, A)'

   ;  Generic HDF file information:
         FOR itag = 0, 7 DO BEGIN
            PRINTF, log_unit, FORMAT = fmt2, $
               itag, tagnames[itag], strstr(meta_data.(itag))
         ENDFOR
         PRINTF, log_unit

   ;  Number of Grids in this HDF file:
         PRINTF, log_unit, FORMAT = fmt2, $
            8, tagnames[8], strstr(meta_data.(8))

   ;  Print the rest of the structure:
         FOR itag = 9, ntags - 1 DO BEGIN
            IF (STRPOS(strstr(meta_data.(itag)), 'Band') GT 0) THEN $
               PRINTF, log_unit
               PRINTF, log_unit, FORMAT = fmt2, $
                  itag, tagnames[itag], strstr(meta_data.(itag))
         ENDFOR

         FREE_LUN, log_unit
         CLOSE, log_unit

         IF (verbose GT 0) THEN BEGIN
            PRINT, 'Saved ' + log_fspecs[i]
         ENDIF
      ENDIF
   ENDFOR

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
