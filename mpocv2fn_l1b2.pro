FUNCTION mpocv2fn_l1b2, misr_mode, misr_path, misr_orbit, misr_camera, $
   misr_version, l1b2_fspec, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates the MISR L1B2 Georectified Radiance
   ;  Product (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance
   ;  file specification (path and name) corresponding to the input
   ;  arguments MODE, PATH and ORBIT numbers, the CAMERA name and the
   ;  version number.
   ;
   ;  ALGORITHM: This function relies on the MISR TOOLKIT function
   ;  MTK_MAKE_FILENAME to generate the desired L1B2 Georectified Radiance
   ;  Product (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance
   ;  output filename, and prepends the appropriate directory address on
   ;  the current computer.
   ;
   ;  SYNTAX: rc = mpocv2fn_l1b2(misr_mode, misr_path, misr_orbit, $
   ;  misr_camera, misr_version, l1b2_fspec, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_camera {STRING} [I]: The selected MISR  name.
   ;
   ;  *   misr_version STRING [I]: The MISR file version number.
   ;
   ;  *   l1b2_fspec {STRING} [O]: The name of the corresponding MISR L1B2
   ;      GRP ToA radiance file.
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
   ;      provided in the call. The output argument l1b2_fspec contains
   ;      the name of the MISR L1B2 GRP ToA radiance file.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output argument l1b2_fspec may be undefined,
   ;      incomplete or useless.
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
   ;  *   Error 140: Input argument misr_camera is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 210: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 310: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_MAKE_FILENAME.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_camera.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well with GM and LM files.
   ;
   ;  *   NOTE 2: This function performs the reverse operation of
   ;      fn2pocv_l1b2.pro.
   ;
   ;  *   NOTE 3: This function does not check whether the resulting
   ;      fialename corresponds to an existing or readable file on the
   ;      current computer.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'LM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_camera = 'CF'
   ;      IDL> misr_version = 'F03_0024'
   ;      IDL> rc = mpocv2fn_l1b2(misr_mode, misr_path, $
   ;         misr_orbit, misr_camera, misr_version, l1b2_fspec, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + $
   ;         ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;      IDL> PRINT, 'l1b2_fspec = ' + l1b2_fspec
   ;      l1b2_fspec = /Volumes/MISR_Data3/P168/L1_LM/
   ;         MISR_AM1_GRP_TERRAIN_LM_P168_O068050_CF_F03_0024.hdf
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–03: Version 0.9 — Initial release under the name
   ;      pocv2fn_l1b2_gm.pro
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–08: Version 1.1 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro, and add a test
   ;      to verify the existence of the specified file at the expected
   ;      location.
   ;
   ;  *   2018–05–07: Version 1.2 — Add the misr_mode input positional
   ;      parameter, merge this function with its twin pocv2fn_l1b2_lm.pro
   ;      and change the name to pocv2fn_l1b2.pro.
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
   l1b2_fspec = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_mode, misr_path, misr_orbit, ' + $
            'misr_camera, misr_version, l1b2_fspec.'
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
   ;  positional parameter 'misr_camera' is invalid:
      rc = chk_misr_camera(misr_camera, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond(idx)
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
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the directory that should contain the specified file:
   gen_fpath = root_dirs[1] + misr_path_str + '/L1_' + misr_mode + '/'
   fpath = FILE_SEARCH(gen_fpath, COUNT = n_fpath)

   status = MTK_MAKE_FILENAME(fpath[0], $
      'GRP_TERRAIN_' + misr_mode, misr_camera, misr_path, misr_orbit, $
      misr_version, l1b2_fspec)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_MAKE_FILENAME = ' + strstr(status)
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
