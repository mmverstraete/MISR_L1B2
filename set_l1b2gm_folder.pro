FUNCTION set_l1b2gm_folder, $
   misr_path, $
   l1b2gm_fpath, $
   n_l1b2gm_files, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function sets the path to the folder containing the
   ;  MISR L1B2 files for the specified PATH.
   ;
   ;  ALGORITHM: By default, this function sets the path to the folder
   ;  containing the MISR L1B2 files according to the settings included in
   ;  the function set_roots_vers; the optional input keyword parameter
   ;  l1b2gm_folder overrides this setting. The function also checks that
   ;  this folder is available for reading.
   ;
   ;  SYNTAX: rc = set_l1b2gm_folder(misr_path, $
   ;  l1b2gm_fpath, n_l1b2gm_files, $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   l1b2gm_fpath {STRING} [O]: The path to the folder containing the
   ;      MISR L1B2 files for the specified PATH.
   ;
   ;  *   n_l1b2gm_files {LONG} [O]: The number of L1B2 files residing in
   ;      the l1b2gm_folder.
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
   ;      set_roots_vers.pro): The MISR L1B2 version identifier to use
   ;      instead of the default value.
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
   ;      l1b2gm_fpath contains the the path to the folder containing the
   ;      MISR L1B2 files for the specified PATH.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter l1b2gm_fpath may be
   ;      undefined, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: Unrecognized misr_mode in a CASE statement.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and the optional input
   ;      keyword parameter l1b2gm_folder is not specified.
   ;
   ;  *   Error 300: The input folder l1b2gm_fpath does not exist.
   ;
   ;  *   Error 310: The input folder l1b2gm_fpath points to multiple
   ;      directories.
   ;
   ;  *   Error 320: The folder l1b2gm_fpath is not found, is not a
   ;      directory or is not readable.
   ;
   ;  *   Error 330: The folder l1b2_path does not contain any L1B2 files.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_dir.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function does not currently distinguish between
   ;      Ellipsoid and Terrain projected data. The MISR-HR processing
   ;      system focuses mainly on Terrain projected data.
   ;
   ;  *   NOTE 2: This function ONLY handles Global Mode files, because
   ;      Local Mode file names require the specification of a site name.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> l1b2gm_folder = ''
   ;      IDL> l1b2gm_version = ''
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = set_l1b2gm_folder(misr_path, $
   ;         l1b2gm_fpath, n_l1b2gm_files, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, $
   ;         L1B2GM_VERSION = l1b2gm_version, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> IF (rc EQ 0) THEN $
   ;         PRINT, 'Processing nominal: rc = ' + strstr(rc) + '.'
   ;      Processing nominal: rc = 0.
   ;      IDL> PRINT, 'l1b2gm_fpath = ' + l1b2gm_fpath
   ;      l1b2gm_fpath = /Volumes/MISR_Data0/P168/L1_GM/
   ;      IDL> PRINT, 'n_l1b2gm_files = ' + strstr(n_l1b2gm_files)
   ;      n_l1b2gm_files = 3861
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
   ;  *   2019–05–05: Version 1.0 — Initial release.
   ;
   ;  *   2019–05–06: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–10: Version 2.01 — Rename this function from
   ;      set_l1b2_folder.pro to set_l1b2gm_folder.pro.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–10–27: Version 2.1.1 — Delete input positional parameter
   ;      misr_mode since this function applies only to Global Mode files,
   ;      and update the documentation.
   ;
   ;  *   2020–03–06: Version 2.1.2 — Update the code to handle input path
   ;      names with wildcard characters.
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
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, l1b2gm_fpath, ' + $
            'n_l1b2gm_files.'
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
   misr_mode = 'GM'
   IF (~KEYWORD_SET(l1b2gm_version)) THEN BEGIN
      CASE misr_mode OF
         'GM': l1b2gm_version = versions[2]
         ELSE: BEGIN
            error_code = 200
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Unrecognized misr_mode.'
            RETURN, error_code
         END
      ENDCASE
   ENDIF

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF ((l1b2 AND (~KEYWORD_SET(l1b2gm_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond + '. And the optional input ' + $
         'keyword parameters l1b2gm_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing the input L1B2 files
   ;  if it has not been set previously:
   IF (KEYWORD_SET(l1b2gm_folder)) THEN BEGIN
      rc = force_path_sep(l1b2gm_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      l1b2gm_fpath = l1b2gm_folder
   ENDIF ELSE BEGIN
      l1b2gm_fpath = root_dirs[1] + misr_path_str + PATH_SEP() + $
         'L1_' + misr_mode + PATH_SEP()
   ENDELSE

   ;  Convert wildcard characters if any are present:
   tst1 = STRPOS(l1b2gm_fpath, '*')
   tst2 = STRPOS(l1b2gm_fpath, '?')
   IF ((tst1 GE 0) OR (tst2 GE 0)) THEN BEGIN
      fp = FILE_SEARCH(l1b2gm_fpath, COUNT = n_fp)
      IF (debug AND (n_fp NE 1)) THEN BEGIN
         CASE n_fp OF
            0: BEGIN
               error_code = 300
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + l1b2gm_fpath + $
                  ' does not exist.'
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 310
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + l1b2gm_fpath + $
                  ' points to multiple directories.'
               RETURN, error_code
            END
         ENDCASE
      ENDIF
      l1b2gm_fpath = fp[0]
      rc = force_path_sep(l1b2gm_fpath)
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  file 'l1b2gm_fpath' does not exist or is unreadable:
   IF (debug) THEN BEGIN
      res = is_readable_dir(l1b2gm_fpath)
      IF (res EQ 0) THEN BEGIN
         error_code = 320
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The input folder ' + l1b2gm_fpath + $
            ' is not found, is not a directory or is not readable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  directory 'l1b2gm_fpath' does not contain L1B2 files of the specified or
   ;  default Version:
   pattern = l1b2gm_fpath + 'MISR*GRP_TERRAIN_GM*' + l1b2gm_version + '.hdf'
   l1b2_files = FILE_SEARCH(pattern, COUNT = n_l1b2gm_files)
   IF (n_l1b2gm_files EQ 0) THEN BEGIN
      error_code = 330
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The folder ' + l1b2gm_fpath + ' does not contain any L1B2 ' + $
         'files for Version ' + l1b2gm_version + '.'
      RETURN, error_code
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
