FUNCTION find_l1b2lm_files, $
   misr_site, $
   misr_path, $
   misr_orbit, $
   l1b2lm_files, $
   L1B2LM_FOLDER = l1b2lm_folder, $
   L1B2LM_VERSION = l1b2lm_version, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function provides the file specifications of the 9
   ;  MISR L1B2 Local Mode radiance files corresponding to the specified
   ;  PATH and ORBIT, if they are available in the expected folder. These
   ;  file specifications are provided in their native order: DF, CF, …,
   ;  AN, …, CA, DA.
   ;
   ;  ALGORITHM: This function reports the file specifications (path +
   ;  names) of the 9 MISR L1B2 Georectified Radiance Product (GRP)
   ;  Terrain-Projected Top of Atmosphere (ToA) Local Mode Radiance files
   ;  for the specified PATH and ORBIT in the default or specified folder,
   ;  for the default or specified version, and verifies that they are
   ;  readable.
   ;
   ;  SYNTAX: rc = find_l1b2lm_files(misr_site, misr_path, misr_orbit, $
   ;  l1b2lm_files, L1B2LM_FOLDER = l1b2lm_folder, $
   ;  L1B2LM_VERSION = l1b2lm_version, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_site{STRING} [I]: The selected MISR Site name.
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   l1b2lm_files {STRING array} [O]: The file specifications (path
   ;      and filenames) of the 9 MISR L1B2 GRP LM ToA radiance files for
   ;      the specified misr_site, misr_path and misr_orbit, in the native
   ;      order DF to DA.
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
   ;      l1b2lm_files contains the specifications of the 9 MISR L1B2 GRP
   ;      ToA radiance files for the specified MODE, PATH and ORBIT.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided. The output positional parameter l1b2lm_files may be
   ;      inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
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
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 202: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 212: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and the optional input
   ;      keyword parameter l1b2lm_folder is not specified.
   ;
   ;  *   Error 300: The input folder l1b2lm_fpath does not exist.
   ;
   ;  *   Error 310: The input folder l1b2lm_fpath points to multiple
   ;      directories.
   ;
   ;  *   Error 320: The input folder l1b2lm_fpath is not a directory or
   ;      not readable.
   ;
   ;  *   Error 330: The input folder l1b2lm_fpath does not contain any
   ;      L1B2 LM files for selected MISR PATH and ORBIT.
   ;
   ;  *   Error 340: The input folder l1b2lm_fpath contains multiple L1B2
   ;      LM files for selected MISR PATH and ORBIT.
   ;
   ;  *   Error 350: At least one of the MISR L1B2 GRP LM ToA radiance
   ;      files l1b2lm_files[cam] in the input folder l1b2lm_fpath is not
   ;      readable.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_MAKE_FILENAME.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_frompath.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_dir.pro
   ;
   ;  *   is_readable_file.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_cap.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: If specified, the optional keyword parameter
   ;      L1B2LM_FOLDER overrides the default address set in
   ;      set_roots_vers.pro.
   ;
   ;  *   NOTE 2: If specified, the optional keyword parameter
   ;      L1B2LM_VERSION overrides the default version identifier set in
   ;      set_roots_vers.pro.
   ;
   ;  *   NOTE 3: This function assumes that the folder l1b2lm_fpath,
   ;      defined either by default or by the input keyword parameter
   ;      l1b2lm_folder, contains all 9 L1B2 LM files for the specified
   ;      misr_site.
   ;
   ;  *   NOTE 4: All 9 MISR L1B2 GRP ToA radiance files for the given
   ;      MODE, PATH and ORBIT are expected to reside in the same folder.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_site = 'Skukuza'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> rc = find_l1b2lm_files(misr_site, misr_path, $
   ;         misr_orbit, l1b2lm_files, /VERBOSE, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + $
   ;         ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;      IDL> PRINT, FILE_DIRNAME(l1b2lm_files[0], /MARK_DIRECTORY)
   ;      /Volumes/MISR_Data0/P168/L1_LM/
   ;      IDL> PRINT, FILE_BASENAME(l1b2lm_files)
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_DF_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_CF_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_BF_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_AF_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_AN_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_AA_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_BA_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_CA_SITE_SKUKUZA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_LM_P168_O068050_DA_SITE_SKUKUZA_F03_0024.hdf
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
   ;  *   2017–07–16: Version 0.8 — Initial release under the name
   ;      chk_l1b2gm_files.
   ;
   ;  *   2017–10–10: Version 0.9 — Changed the function name to
   ;      chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Changed the function name to
   ;      get_l1b2_gm_files.pro.
   ;
   ;  *   2018–04–08: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–05–04: Version 1.3 — Merge this function with its twin
   ;      get_l1b2_lm_files.pro and change the name to
   ;      get_l1b2gm_files.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–12–25: Version 1.6 — Rename this function to
   ;      find_l1b2gm_files.pro and update the documentation.
   ;
   ;  *   2019–02–21: Version 1.7 — Update this function to return the
   ;      file specifications in the native order of MISR cameras.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–06–11: Version 2.11 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–10: Version 2.12 — Create this function using
   ;      find_l1b2gm_files.pro as a template.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2020–03–06: Version 2.1.1 — Update the code to handle input path
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

   ;  Initialize the output positional parameter(s):
   l1b2lm_files = ['']

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_site, misr_path, misr_orbit, ' + $
            'l1b2lm_files.'
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
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames

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
   IF (~KEYWORD_SET(l1b2lm_version)) THEN l1b2lm_version = versions[2]

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the short string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_s, /NOHEADER, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 202
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the short string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_s, /NOHEADER, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 212
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(l1b2lm_folder)) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And the optional input keyword ' + $
            'parameter l1b2lm_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing L1B2 LM files:
   IF (KEYWORD_SET(l1b2lm_folder)) THEN BEGIN
      rc = force_path_sep(l1b2lm_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      l1b2lm_fpath = l1b2lm_folder
   ENDIF ELSE BEGIN
      l1b2lm_fpath = root_dirs[1] + misr_path_str + PATH_SEP() + $
         'L1_LM' + PATH_SEP()
   ENDELSE

   ;  Convert wildcard characters if any are present:
   tst1 = STRPOS(l1b2lm_fpath, '*')
   tst2 = STRPOS(l1b2lm_fpath, '?')
   IF ((tst1 GE 0) OR (tst2 GE 0)) THEN BEGIN
      fp = FILE_SEARCH(l1b2lm_fpath, COUNT = n_fp)
      IF (debug AND (n_fp NE 1)) THEN BEGIN
         CASE n_fp OF
            0: BEGIN
               error_code = 300
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + l1b2lm_fpath + $
                  ' does not exist.'
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 310
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + l1b2lm_fpath + $
                  ' points to multiple directories.'
               RETURN, error_code
            END
         ENDCASE
      ENDIF
      l1b2lm_fpath = fp[0]
      rc = force_path_sep(l1b2lm_fpath)
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  directory 'l1b2lm_fpath' does not exist or is unreadable:
   IF (debug) THEN BEGIN
      res = is_readable_dir(l1b2lm_fpath)
      IF (res EQ 0) THEN BEGIN
         error_code = 320
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The input folder ' + l1b2lm_fpath + $
            ' is not found, not a directory or not readable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Generate the full site name:
   site_name = 'SITE_' + set_cap(misr_site, /ALLCHARS)

   ;  Generate the expected names of the L1B2 files using the MISR Toolkit, in
   ;  their native order: DF, CF, ..., CA, DA:
   l1b2lm_files = STRARR(n_cams)
   header = 'MISR_AM1_GRP_TERRAIN_LM_'
   FOR cam = 0, n_cams - 1 DO BEGIN
      filename = header + misr_path_str + '_' + misr_orbit_str + '_' + $
         cams[cam] + '_' + site_name  + '_' + l1b2lm_version + '.hdf'
      filespec = l1b2lm_fpath + filename

   ;  Remove any wild card characters in that file specification:
      files = FILE_SEARCH(filespec, COUNT = count)
      IF (debug AND (count EQ 0)) THEN BEGIN
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': File ' + filespec + ' not found.'
         RETURN, error_code
      ENDIF
      IF (debug AND (count GT 1)) THEN BEGIN
         error_code = 320
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Multiple L1B2 files found for camera ' + cams[cam] + '.'
         RETURN, error_code
      ENDIF
      l1b2lm_files[cam] = files[0]

   ;  Return to the calling routine with an error message if the input
   ;  file 'l1b2lm_files[cam]' does not exist or is unreadable:
      IF (debug) THEN BEGIN
         res = is_readable_file(l1b2lm_files[cam])
         IF (res EQ 0) THEN BEGIN
            error_code = 330
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
               rout_name + ': The input file ' + l1b2lm_files[cam] + $
               ' does not exist, is not a regular file or is not readable.'
            RETURN, error_code
         ENDIF
      ENDIF
   ENDFOR

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
