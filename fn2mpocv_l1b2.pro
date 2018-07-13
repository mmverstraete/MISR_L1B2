FUNCTION fn2mpocv_l1b2, l1b2_file, misr_mode, misr_path, misr_orbit, $
   misr_camera, misr_version, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function extracts informatio on the MISR MODE, PATH,
   ;  ORBIT, CAMERA and version number from the specified L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Radiance filename.
   ;
   ;  ALGORITHM: This function relies on MISR TOOLKIT functions to extract
   ;  the desired information from the L1B2 Georectified Radiance Product
   ;  (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance filename.
   ;
   ;  SYNTAX:
   ;  rc = fn2mpocv_l1b2(l1b2_file, misr_mode, misr_path, misr_orbit, $
   ;  misr_camera, misr_version, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   l1b2_file {STRING} [I]: The name of a MISR L1B2 GRP ToA radiance
   ;      file.
   ;
   ;  *   misr_mode {STRING} [O]: The MODE of the MISR L1B2 input file.
   ;
   ;  *   misr_path {INTEGER} [O]: The MISR PATH number of the L1B2 input
   ;      file.
   ;
   ;  *   misr_orbit {LONG} [O]: The MISR ORBIT number of the L1B2 input
   ;      file.
   ;
   ;  *   misr_camera {STRING} [O]: The MISR CAMERA name of the L1B2 input
   ;      file.
   ;
   ;  *   misr_version STRING [O]: The version number of the MISR L1B2
   ;      input file.
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
   ;      provided in the call. The output arguments misr_mode, misr_path,
   ;      misr_orbit,
   ;      misr_camera and misr_version contain the desired information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output arguments misr_mode, misr_path, misr_orbit,
   ;      misr_camera and misr_version may be undefined, incomplete or
   ;      useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter l1b2_file is not of type
   ;      STRING.
   ;
   ;  *   Error 120: Input positional parameter l1b2_file is unreadable or
   ;      not found.
   ;
   ;  *   Error 200: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_TYPE.
   ;
   ;  *   Error 210: The input positional parameter l1b2_file is neither
   ;      of type GRP_TERRAIN_GM nor of type GRP_TERRAIN_LM.
   ;
   ;  *   Error 220: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_TO_PATH.
   ;
   ;  *   Error 230: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_TO_ORBIT.
   ;
   ;  *   Error 240: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILEATTR_GET.
   ;
   ;  *   Error 250: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_VERSION.
   ;
   ;  *   Error 200: An exception condition occurred in routine.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   is_readable.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well with GM and LM files.
   ;
   ;  *   NOTE 2: This function performs the reverse operation of
   ;      mpovc2fn.pro.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> l1b2_spec = '/Volumes/MISR_Data3/P168/L1_GM/
   ;         MISR_AM1_GRP_TERRAIN_GM_P168_O068050_AA_F03_0024.hdf'
   ;      IDL> rc = fn2mpocv_l1b2(l1b2_spec, misr_mode, misr_path, $
   ;         misr_orbit, misr_camera, misr_version, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, 'misr_mode = ', misr_mode
   ;      misr_mode = GM
   ;      IDL> PRINT, 'misr_path = ', strstr(misr_path)
   ;      misr_path = 168
   ;      IDL> PRINT, 'misr_orbit = ', strstr(misr_orbit)
   ;      misr_orbit = 68050
   ;      IDL> PRINT, 'misr_camera = ', misr_camera
   ;      misr_camera =  AA
   ;      IDL> PRINT, 'misr_version = ', misr_version
   ;      misr_version = F03_0024
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–03: Version 0.9 — Initial release under the name
   ;      fn2pocv_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–07: Version 1.1 — Add the misr_mode output positional
   ;      parameter, merge this function with its twin fn2pocv_l1b2_lm.pro
   ;      and change the name to
   ;      fn2mpocv_l1b2.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–13: Version 1.6 — Modify the code to ensure that the
   ;      output variable misr_camera is a scalar string and update the
   ;      documentation.
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
   misr_mode = ''
   misr_path = 0
   misr_orbit = 0L
   misr_camera = ''
   misr_version = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): l1b2_file, misr_mode, misr_path, ' + $
            'misr_orbit, misr_camera, misr_version.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input file
   ;  'l1b2_file' is not of type STRING:
      IF (is_string(l1b2_file) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input file ' + strstr(l1b2_file) + ' is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input file
   ;  'l1b2_file' cannot be found or is unreadable:
      rc = is_readable(l1b2_file, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input file ' + strstr(l1b2_file) + $
            ' is unreadable or not found.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Determine the MISR file type:
   status = MTK_FILE_TYPE(l1b2_file, ftype)

   ;  Return to the calling routine with an error message if the input file
   ;  'l1b2_file' is not of type 'GRP_TERRAIN_GM' or 'GRP_TERRAIN_LM':
   IF (debug) THEN BEGIN
      IF (status NE 0) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Status from MTK_FILE_TYPE = ' + strstr(status)
         RETURN, error_code
      ENDIF
      IF ((ftype NE 'GRP_TERRAIN_GM') AND $
         (ftype NE 'GRP_TERRAIN_LM')) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ": The file type is neither 'GRP_TERRAIN_GM' or 'GRP_TERRAIN_LM'."
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Extract the misr_mode from the file type:
   parts = STRSPLIT(ftype, '_', COUNT = nparts, /EXTRACT)
   misr_mode = parts[2]

   ;  Retrieve the MISR Path number:
   status = MTK_FILE_TO_PATH(l1b2_file, misr_path)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_FILE_TO_PATH = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Retrieve the MISR Orbit number:
   status = MTK_FILE_TO_ORBIT(l1b2_file, misr_orbit)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_FILE_TO_ORBIT = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Retrieve the MISR Camera number (See the routine MTK_FILEATTR_LIST
   ;  to get the list of legal attribute names):
   status = MTK_FILEATTR_GET(l1b2_file, 'Camera', val)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 240
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_FILEATTR_GET = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Retrieve the MISR camera name:
   res = set_misr_specs()
   mc = res.CameraNames[val - 1]
   misr_camera = mc[0]

   ;  Retrieve the MISR version number:
   status = MTK_FILE_VERSION(l1b2_file, misr_version)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 250
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_FILE_VERSION = ' + strstr(status)
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
