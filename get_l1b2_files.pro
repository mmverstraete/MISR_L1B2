FUNCTION get_l1b2_files, misr_mode, misr_path, misr_orbit, l1b2_files, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function provides the file specifications (path +
   ;  names) of the 9 MISR L1B2 Georectified Radiance Product (GRP)
   ;  Terrain-Projected Top of Atmosphere (ToA) Radiance files
   ;  corresponding to the given misr_mode, misr_path and misr_orbit, if
   ;  they are available in the expected folder (defined by the function
   ;  set_root_dirs) on the current computer.
   ;
   ;  ALGORITHM: This function reports on the existence of the 9 MISR L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Radiance files for the specified MISR MODE (GM or
   ;  LM), PATH and ORBIT in the folder
   ;  root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’, where root_dirs is
   ;  determined by a call to
   ;  set_root_dirs() and xxx is the misr_path number.
   ;
   ;  SYNTAX: rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, $
   ;  l1b2_files, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: A 2-character parameter indicating
   ;      whether to identify Global (GM) or Local (LM) Mode files.
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   l1b2_files {STRING array} [O]: The file specifications (path and
   ;      filenames) of the 9 MISR L1B2 GRP ToA radiance files of the
   ;      specified misr_mode, expected to be found in
   ;      root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’, where xxx is the
   ;      MISR PATH number.
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
   ;      provided in the call. The output positional parameter l1b2_files
   ;      contains the specifications of the 9 MISR L1B2 GRP ToA radiance
   ;      files for the specified MODE.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided. The output positional parameter l1b2_files is either a
   ;      null string array or an array of file specifications that
   ;      contains strictly fewer or strictly more than 9 items, or some
   ;      of these files may be unreadable.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_mode is invalid.
   ;
   ;  *   Error 120: Input argument misr_path is invalid.
   ;
   ;  *   Error 130: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 200: An exception condition occurred in function path2str.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2str.
   ;
   ;  *   Error 300: No MISR L1B2 GRP ToA radiance files have been found
   ;      in the expected location
   ;      root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’.
   ;
   ;  *   Error 310: Less than 9 MISR L1B2 GRP ToA radiance files have
   ;      been found in the expected location
   ;      root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’.
   ;
   ;  *   Error 320: More than 9 MISR L1B2 GRP ToA radiance files have
   ;      been found in the expected location
   ;      root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’.
   ;
   ;  *   Error 400: At least one of the MISR L1B2 GRP ToA radiance files
   ;      found is not readable.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_readable.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function assumes that the folder
   ;      root_dirs[1] + ’/Pxxx/L1_’ + misr_mode + ’/’ contains full
   ;      ORBITs, i.e., that files contain data for all BLOCKs. If this
   ;      directory also contains subsetted files, i.e., files containing
   ;      data for only 1 or a few BLOCKs, it is possible that more than 9
   ;      files may be present, but this situation should be alleviated by
   ;      removing the subsetted files when the full ORBITs are available.
   ;
   ;  *   NOTE 2: All 9 MISR L1B2 GRP ToA radiance files for the given
   ;      MODE, PATH and ORBIT are expected to reside in the same folder.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, $
   ;         l1b2_files, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ' and excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;      IDL> PRINT, FILE_DIRNAME(l1b2_files[0], /MARK_DIRECTORY)
   ;      /Volumes/MISR_Data3/P168/L1_GM/
   ;      IDL> PRINT, FILE_BASENAME(l1b2_files)
   ;      MISR_AM1_GRP_TERRAIN_GM_P168_O068050_AA_F03_0024.hdf MISR_AM1_GRP_TERRAIN_GM_P168_O068050_AF_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_GM_P168_O068050_AN_F03_0024.hdf MISR_AM1_GRP_TERRAIN_GM_P168_O068050_BA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_GM_P168_O068050_BF_F03_0024.hdf MISR_AM1_GRP_TERRAIN_GM_P168_O068050_CA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_GM_P168_O068050_CF_F03_0024.hdf MISR_AM1_GRP_TERRAIN_GM_P168_O068050_DA_F03_0024.hdf
   ;      MISR_AM1_GRP_TERRAIN_GM_P168_O068050_DF_F03_0024.hdf
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–16: Version 0.8 — Initial release under the name
   ;      chk_l1b2_files.
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
   ;      get_l1b2_lm_files.pro and change the name to get_l1b2_files.pro.
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
   l1b2_files = ['']

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_mode, misr_path, misr_orbit, ' + $
            'l1b2_files.'
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
   ENDIF

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()
   IF ((debug) AND (root_dirs[0] EQ 'Unrecognized computer')) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Unrecognized computer.'
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Search for the 9 L1B2 Terrain-projected files implied by the given
   ;  MISR Mode, Path and Orbit parameters:
   l1b2_path = root_dirs[1] + misr_path_str + PATH_SEP() + $
      'L1_' + misr_mode + PATH_SEP()
   l1b2_prefix = 'MISR_AM1_GRP_TERRAIN_' + misr_mode + '_'
   l1b2_fname = l1b2_prefix + misr_path_str + '_' + $
      misr_orbit_str + '*.hdf'
   l1b2_files = FILE_SEARCH(l1b2_path, l1b2_fname, COUNT = num_files)

   IF (debug) THEN BEGIN

   ;  Manage exception conditions:
      IF (num_files EQ 0) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Directory ' + l1b2_path + $
            ' does not contain any L1B2 files for MISR Mode ' + $
            misr_mode + ' Path ' + misr_path_str + ' and Orbit ' + $
            misr_orbit_str + '.'
         RETURN, error_code
      ENDIF

      IF (num_files LT 9) THEN BEGIN
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Directory ' + l1b2_path + ' contains fewer than 9 L1B2 ' + $
            'files for MISR Mode ' + misr_mode + ' Path ' + misr_path_str + $
            ' and Orbit ' + misr_orbit_str + '.'
         RETURN, error_code
      ENDIF
      IF (num_files GT 9) THEN BEGIN
         error_code = 320
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Directory ' + l1b2_path + 'contains more than 9 L1B2 ' + $
            'files for MISR Mode ' + misr_mode + ' Path ' + misr_path_str + $
            ' and Orbit ' + misr_orbit_str + '.'
         RETURN, error_code
      ENDIF

   ;  Check that each of these files is readable:
      FOR i = 0, num_files - 1 DO BEGIN
         IF (is_readable(l1b2_files[i], DEBUG = debug, $
         EXCPT_COND = excpt_cond) NE 1) THEN BEGIN
            error_code = 400
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': L1B2 file ' + l1b2_files[i] + ' is unreadable.'
            RETURN, error_code
         ENDIF
      ENDFOR
   ENDIF

   RETURN, return_code

END
