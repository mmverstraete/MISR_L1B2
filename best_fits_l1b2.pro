FUNCTION best_fits_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   misr_camera, misr_band, n_masks, land_mask, water_mask, clear_land_masks, $
   clear_water_masks, cloud_masks, best_fits, AGP_VERSION = agp_version, $
   VERBOSE = verbose, SCATTERPLOT = scatterplot, DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates statistical information, including
   ;  best linear fits, that can be used to estimate a bad or missing
   ;  value in the target MISR L1B2 radiance array identified by the
   ;  selected MODE, PATH, ORBIT, BLOCK, CAMERA and BAND, based on
   ;  non-missing values available in one of the other 35 source (camera
   ;  and band) data channels for the same MODE, PATH, ORBIT and BLOCK
   ;  data acquisition.
   ;
   ;  ALGORITHM: This function compute the Pearson correlation
   ;  coefficients, best linear fits and associated statistical parameters
   ;  between the target data channel and all other (35) source data
   ;  channels available for the selected MISR MODE, PATH, ORBIT and BLOCK
   ;  data acquisition. Depending on the value of the input positional
   ;  parameter n_masks, these statistics may be computed for all
   ;  available values in the source and target data channels (n_masks set
   ;  to 1), separately for land masses and water bodies (n_masks set to
   ;  2), or separately for clear land masses, clear water bodies and
   ;  cloud patches.
   ;
   ;  SYNTAX:
   ;  rc = best_fits_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  misr_camera, misr_band, n_masks, land_mask, water_mask, $
   ;  clear_land_masks, clear_water_masks, cloud_masks, best_fits, $
   ;  AGP_VERSION = agp_version, VERBOSE = verbose, SCATTERPLOT = scatterplot, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  *   misr_camera {STRING} [I]: The selected MISR CAMERA (target).
   ;
   ;  *   misr_band {STRING} [I]: The selected MISR BAND (target).
   ;
   ;  *   n_masks {INTEGER} [I]: The number of masks to use: 1 to compute
   ;      bulk statistics for all geophysical target types, 2 to compute
   ;      statistics separately for land masses and water bodies, or 3 to
   ;      compute statistics separately for clear land masses, clear water
   ;      bodies and cloud patches.
   ;
   ;  *   land_mask {BYTE array} [I]: The land mask for the selected MISR
   ;      PATH and BLOCK, as specified by the corresponding AGP file,
   ;      valid for all cameras.
   ;
   ;  *   water_mask {BYTE array} [I]: The water mask for the selected
   ;      MISR PATH and BLOCK, as specified by the corresponding AGP file,
   ;      valid for all cameras.
   ;
   ;  *   clear_land_masks {BYTE array} [I]: The set of 9 masks
   ;      identifying the clear land masses in each camera data file.
   ;
   ;  *   clear_water_masks {BYTE array} [I]: The set of 9 masks
   ;      identifying the clear water bodies in each camera data file.
   ;
   ;  *   cloud_masks {BYTE array} [I]: The set of 9 masks identifying the
   ;      cloud patches in each camera data file.
   ;
   ;  *   best_fits {STRUCTURE} [O]: The output structure containing the
   ;      desired statistical information.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AGP_VERSION = agp_version {STRING} [I] (Default value: ’F01_24’):
   ;      The AGP version identifier to use.
   ;
   ;  *   VERBOSE = verbose {INTEGER} [I] (Default value: 0): Flag to
   ;      request saving operational details in a separate log file.
   ;
   ;  *   SCATTERPLOT = scatterplot {INT} [I] (Default value: 0): Flag to
   ;      generate (1) or skip (0) a scatterplot of the two best
   ;      correlated data channels for each of the cases specified by
   ;      n_masks.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. If the input positional parameter n_masks
   ;      is set to 1, all valid values that are common to the source and
   ;      the target data channels are used; if it is set to 2, those
   ;      statistics are computed separately for the land areas and water
   ;      bodies, as classified by the corresponding static MISR AGP map;
   ;      and if it is set to 3, those statistics are computed separately
   ;      for the clear land masses, the clear water bodies, and the
   ;      cloudy patches in the scene. The output positional parameter
   ;      best_fits contains the desired statistical information and the
   ;      scatterplots as well as the log file have been saved if
   ;      requested.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter best_fits may be empty
   ;      and the scatterplots as well as the log file may be inexistent,
   ;      incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 120: Input positional parameter misr_path is invalid.
   ;
   ;  *   Error 130: Input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 140: Input positional parameter misr_block is invalid.
   ;
   ;  *   Error 150: Input positional parameter misr_camera is invalid.
   ;
   ;  *   Error 160: Input positional parameter misr_band is invalid.
   ;
   ;  *   Error 170: Input positional parameter n_masks is not an integer.
   ;
   ;  *   Error 172: Input positional parameter n_masks is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in orbit2date.pro.
   ;
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 310: An exception condition occurred in fn2mpocv_l1b2.pro.
   ;
   ;  *   Error 320: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 330: An exception condition occurred in fn2mpocv_l1b2.pro.
   ;
   ;  *   Error 340: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 350: The source and target data buffers are of different
   ;      sizes.
   ;
   ;  *   Error 400: An exception condition occurred in
   ;      get_l1b2_files.pro.
   ;
   ;  *   Error 510: An exception condition occurred in plt_scatt_gen when
   ;      generating the scatterplot for land masses.
   ;
   ;  *   Error 520: An exception condition occurred in plt_scatt_gen when
   ;      generating the scatterplot for water bodies.
   ;
   ;  *   Error 530: An exception condition occurred in plt_scatt_gen when
   ;      generating the scatterplot for cloud patches.
   ;
   ;  *   Error 540: An exception condition occurred in is_writable.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_band
   ;
   ;  *   chk_misr_block
   ;
   ;  *   chk_misr_camera
   ;
   ;  *   chk_misr_mode
   ;
   ;  *   chk_misr_orbit
   ;
   ;  *   chk_misr_path
   ;
   ;  *   is_integer
   ;
   ;  *   is_writable
   ;
   ;  *   plt_scatt_gen
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function returns the results in decreasing order of
   ;      the Pearson correlation coefficient between the source and the
   ;      target.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_block = 110
   ;      IDL> misr_camera = 'DF'
   ;      IDL> misr_band = 'NIR'
   ;      IDL> rc1 = make_l1b2_masks(misr_path, misr_orbit, misr_block, land_mask, $
   ;      IDL>    water_mask, rccm_cloud, clear_land_masks, clear_water_masks, $
   ;      IDL>    cloud_masks, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> n_masks = 3
   ;      IDL> rc3 = best_fits_l1b2(misr_mode, misr_path, misr_orbit, $
   ;      IDL>    misr_block, misr_camera, misr_band, n_masks, land_mask, $
   ;      IDL>    water_mask, clear_land_masks, clear_water_masks, cloud_masks, $
   ;      IDL>    best_fits, /VERBOSE, /DEBUG, EXCPT_COND = excpt_cond)
   ;      The log file has been saved in /Users/michel/MISR_HR/Outcomes/P168_O068050_B110/L1B2_GM/
   ;         Bestfits_L1B2_BRF_GM_P168_O068050_B110_DF_NIR.txt
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–09: Version 0.8 — Initial release.
   ;
   ;  *   2018–09–19: Version 0.9 — Upgrade the code to compute the
   ;      statistics only on valid data, i.e., where BRF > 0.0 (as before)
   ;      and RDQI < 2 (new), and to generate nominal results whenever
   ;      there are no common valid pixel values suitable to compute the
   ;      statistics.
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
   IF (~KEYWORD_SET(agp_version)) THEN agp_version = 'F01_24'
   IF (KEYWORD_SET(verbose)) THEN verbose = 1
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 13
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_mode, misr_path, misr_orbit, ' + $
            'misr_block, misr_camera, misr_band, n_masks, land_mask, ' + $
            'water_mask, clear_land_masks, clear_water_masks, ' + $
            'cloud_masks, best_fits.'
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
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_camera' is invalid:
      rc = chk_misr_camera(misr_camera, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_band' is invalid:
      rc = chk_misr_band(misr_band, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_masks' is not an integer:
      IF (is_integer(n_masks) NE 1) THEN BEGIN
         error_code = 170
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_masks is not an integer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_masks' is invalid:
      IF ((n_masks LT 1) OR (n_masks GT 3)) THEN BEGIN
         error_code = 172
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_masks is invalid.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames
   n_chns = misr_specs.NChannels

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name)

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Initialize the output positional parameter(s):
   n_sources = n_chns - 1

   ;  Define the required output arrays as specified ny the input positional
   ;  parameter n_masks:

   ;  Define the output land arrays, which are always used:
   best_land_cams = STRARR(n_sources)
   best_land_bnds = STRARR(n_sources)
   best_land_npts = LONARR(n_sources)
   best_land_rsmds = FLTARR(n_sources)
   best_land_cors = FLTARR(n_sources)
   best_land_as = FLTARR(n_sources)
   best_land_bs = FLTARR(n_sources)
   best_land_chisqs = FLTARR(n_sources)
   best_land_probs = FLTARR(n_sources)

   ;  Define the output water arrays, used if n_masks is set to 2 or 3:
   IF (n_masks GT 1) THEN BEGIN
      best_water_cams = STRARR(n_sources)
      best_water_bnds = STRARR(n_sources)
      best_water_npts = LONARR(n_sources)
      best_water_rsmds = FLTARR(n_sources)
      best_water_cors = FLTARR(n_sources)
      best_water_as = FLTARR(n_sources)
      best_water_bs = FLTARR(n_sources)
      best_water_chisqs = FLTARR(n_sources)
      best_water_probs = FLTARR(n_sources)
   ENDIF

   ;  Define the output cloud arrays:
   IF (n_masks GT 2) THEN BEGIN
      best_cloud_cams = STRARR(n_sources)
      best_cloud_bnds = STRARR(n_sources)
      best_cloud_npts = LONARR(n_sources)
      best_cloud_rsmds = FLTARR(n_sources)
      best_cloud_cors = FLTARR(n_sources)
      best_cloud_as = FLTARR(n_sources)
      best_cloud_bs = FLTARR(n_sources)
      best_cloud_chisqs = FLTARR(n_sources)
      best_cloud_probs = FLTARR(n_sources)
   ENDIF

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str
   pob_str_space = pob_str.Replace('_', ' ')

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the resolution of the target data channel (a flag used later on to
   ;  downscale or upscale data fields as appropriate):
   target_resol = 275
   IF ((misr_mode EQ 'GM') AND $
      (misr_camera NE 'AN') AND $
      (misr_band NE 'Red')) THEN target_resol = 1100

   ;  Locate the 9 L1B2 input files corresponding to the specified MISR Mode,
   ;  Path, and Orbit (listed in alphabetical order of their names, AA, AF,
   ;  AN, BA, BF, CA, CF, DA, DF):
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_l1b2_files = N_ELEMENTS(l1b2_files)

   ;  Identify the file containing the target MISR L1B2 data channel:
   cam_patt = '_' + misr_camera + '_'
   FOR i = 0, n_l1b2_files - 1 DO BEGIN
      idx = STRPOS(l1b2_files[i], cam_patt)
      IF (idx GT 1) THEN BEGIN
         target_l1b2_file = l1b2_files[i]
         BREAK
      ENDIF
   ENDFOR

   ;  Set the target region of interest to the selected Block:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, misr_block, $
      misr_block, region)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error encountered in MTK_SETREGION_BY_PATH_BLOCKRANGE.'
      RETURN, error_code
   ENDIF

   ;  Characterize and read the L1B2 data for the target channel:
   rc = fn2mpocv_l1b2(target_l1b2_file, target_mode, target_path, $
      target_orbit, target_cam, target_version, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   target_bnd = misr_band
   target_grid = misr_band + 'Band'
   target_field = misr_band + ' Brf'
   status = MTK_READDATA(target_l1b2_file, target_grid, target_field, $
      region, target_databuf, mapinfo)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 320
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error encountered in MTK_READDATA while reading ' + $
         target_l1b2_file
      RETURN, error_code
   ENDIF

   ;  Read the RDQI field for the same grid of the target channel:
   target_field_rd = misr_band + ' RDQI'
   status = MTK_READDATA(target_l1b2_file, target_grid, target_field_rd, $
      region, target_databuf_rd, mapinfo)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 322
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error encountered in MTK_READDATA while reading ' + $
         target_l1b2_file
      RETURN, error_code
   ENDIF

   ; Initialize the best Pearson correlation coefficient so far to 0.0:
   best_land_cors[*] = 0.0
   IF (n_masks GT 1) THEN best_water_cors[*] = 0.0
   IF (n_masks GT 2) THEN best_cloud_cors[*] = 0.0
   current_max_land_cc = -1.0
   IF (n_masks GT 1) THEN current_max_water_cc = -1.0
   IF (n_masks GT 2) THEN current_max_cloud_cc = -1.0

   ;  Loop over all 9 MISR L1B2 files (or cameras, in alphabetical order):
   iter = 0
   FOR cam = 0, n_l1b2_files - 1 DO BEGIN

   ;  Identify the potential source file by name:
      source_l1b2_file = l1b2_files[cam]

   ;  Identify the MISR camera of that potential source file:
      rc = fn2mpocv_l1b2(source_l1b2_file, misr_mode, source_path, $
         source_orbit, source_cam, source_version, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND (rc NE 0)) THEN BEGIN
         error_code = 330
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Loop over the 4 spectral bands of that file (or camera, in the order
   ;  specified by the function 'set_misr_specs.pro'):
      FOR bnd = 0, n_bnds - 1 DO BEGIN
         source_bnd = misr_bnds[bnd]

   ;  Skip the source camera and band combination corresponding to the target
   ;  data channel:
         IF ((source_cam EQ target_cam) AND $
            (source_bnd EQ target_bnd)) THEN BEGIN
            CONTINUE
         ENDIF ELSE BEGIN

   ;  Set the resolution of the source data channel:
            source_resol = 275
            IF ((misr_mode EQ 'GM') AND (source_cam NE 'AN')) THEN BEGIN
               IF (source_bnd NE 'Red') THEN source_resol = 1100
            ENDIF

   ;  Save the camera and band names for the current iteration:
            best_land_cams[iter] = source_cam
            best_land_bnds[iter] = source_bnd

            IF (n_masks GT 1) THEN best_water_cams[iter] = source_cam
            IF (n_masks GT 1) THEN best_water_bnds[iter] = source_bnd

            IF (n_masks GT 2) THEN best_cloud_cams[iter] = source_cam
            IF (n_masks GT 2) THEN best_cloud_bnds[iter] = source_bnd
         ENDELSE

   ;  Read the L1B2 data for that source channel:
         source_grid = source_bnd + 'Band'
         source_field = source_bnd + ' Brf'
         status = MTK_READDATA(source_l1b2_file, source_grid, source_field, $
            region, source_databuf, mapinfo)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 340
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error encountered in MTK_READDATA while reading ' + $
               source_l1b2_file
            RETURN, error_code
         ENDIF

   ;  Read the RDQI field for the same grid of the source channel:
         source_field_rd = source_bnd + ' RDQI'
         status = MTK_READDATA(source_l1b2_file, source_grid, source_field_rd, $
            region, source_databuf_rd, mapinfo)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 342
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error encountered in MTK_READDATA while reading ' + $
               target_l1b2_file
            RETURN, error_code
         ENDIF

   ;  Ensure that the spatial resolutions of the target and the source data
   ;  channels match, and if not, adjust the spatial resolution of the source
   ;  data channel:
         IF ((target_resol EQ 1100) AND (source_resol EQ 275)) THEN BEGIN
            source_databuf = hr2lr(source_databuf)
         ENDIF
         IF ((target_resol EQ 275) AND (source_resol EQ 1100)) THEN BEGIN
            source_databuf = lr2hr(source_databuf)
         ENDIF
         IF ((debug) AND (size(source_databuf, /N_ELEMENTS) NE $
            size(target_databuf, /N_ELEMENTS))) THEN BEGIN
            error_code = 350
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Target databuf contains ' + $
               strstr(size(target_databuf, /N_ELEMENTS)) + $
               ' elements but source target contains ' + $
               strstr(size(source_databuf, /N_ELEMENTS)) + $
               ' elements.'
            RETURN, error_code
         ENDIF

   ;  Locate the land pixels with valid (BRF > 0 and RDQI < 2) values in
   ;  both the source and the target data channels:
         IF (n_masks EQ 1) THEN BEGIN
            kdx_lnd = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2), n_lnd_pts)
            best_land_npts[iter] = n_lnd_pts
         ENDIF
         IF (n_masks EQ 2) THEN BEGIN
            kdx_lnd = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2) AND $
               (land_mask EQ 1B), n_lnd_pts)
            best_land_npts[iter] = n_lnd_pts
         ENDIF
         IF (n_masks EQ 3) THEN BEGIN
            kdx_lnd = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2) AND $
               (clear_land_masks[cam, *, *] EQ 2B), n_lnd_pts)
            best_land_npts[iter] = n_lnd_pts
         ENDIF

   ;  Locate the water pixels with valid (BRF > 0 and RDQI < 2) values in
   ;  both the source and the target data channels:
         IF (n_masks EQ 2) THEN BEGIN
            kdx_wat = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2) AND $
               (water_mask EQ 1B), n_wat_pts)
            best_water_npts[iter] = n_wat_pts
         ENDIF
         IF (n_masks GE 3) THEN BEGIN
            kdx_wat = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2) AND $
               (clear_water_masks[cam, *, *] EQ 2B), n_wat_pts)
            best_water_npts[iter] = n_wat_pts
         ENDIF

   ;  Locate the cloud pixels with valid (BRF > 0 and RDQI < 2) values in
   ;  both the source and the target data channels:
         IF (n_masks EQ 3) THEN BEGIN
            kdx_cld = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2) AND $
               (cloud_masks[cam, *, *] EQ 1B), n_cld_pts)
            best_cloud_npts[iter] = n_cld_pts
         ENDIF

   ;  Compute the statistical fits as requested:

   ;  === Statistics for land masses (or the entire Block, if n_masks = 1) ===

         IF (n_lnd_pts GT 0) THEN BEGIN

   ;  Extract the land values wherever the source and the target are both
   ;  valid and available:
            source_lnd_data = source_databuf[kdx_lnd]
            target_lnd_data = target_databuf[kdx_lnd]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target land values wherever they are both valid and available:
            numer = TOTAL((source_lnd_data - target_lnd_data) * $
               (source_lnd_data - target_lnd_data))
            rmsd = SQRT(numer / n_lnd_pts)
            best_land_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  land values wherever they are both valid and available:
            cc = CORRELATE(source_lnd_data, target_lnd_data, /DOUBLE)
            cc_lnd = FLOAT(cc)
            best_land_cors[iter] = cc_lnd

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting:
            IF (KEYWORD_SET(scatterplot) AND $
               (cc_lnd GT current_max_land_cc)) THEN BEGIN
               current_max_land_cc = cc_lnd
               best_source_land_databuf = source_databuf
            ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  land values wherever they are both valid and available:
            res = LINFIT(source_lnd_data, target_lnd_data, CHISQR = chi, $
               PROB = prob, /DOUBLE)
            best_land_as[iter] = res[0]
            best_land_bs[iter] = res[1]
            best_land_chisqs[iter] = chi
            best_land_probs[iter] = prob

   ;  Consider the case where there are no common valid land pixel values:
         ENDIF ELSE BEGIN
            best_land_rsmds[iter] = 1.0E10
            best_land_cors[iter] = 0.0
            best_land_as[iter] = 0.0
            best_land_bs[iter] = 0.0
            best_land_chisqs[iter] = 1.0E10
            best_land_probs[iter] = 0.0
         ENDELSE

   ;  === Statistics for water bodies ===

         IF (n_masks GE 2) THEN BEGIN
            IF (n_wat_pts GT 0) THEN BEGIN

   ;  Extract the water values wherever the source and the target are both
   ;  available:
               source_wat_data = source_databuf[kdx_wat]
               target_wat_data = target_databuf[kdx_wat]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target water values wherever they are both available:
               numer = TOTAL((source_wat_data - target_wat_data) * $
                  (source_wat_data - target_wat_data))
               rmsd = SQRT(numer / n_wat_pts)
               best_water_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  water values wherever they are both available:
               cc = CORRELATE(source_wat_data, target_wat_data, /DOUBLE)
               cc_wat = FLOAT(cc)
               best_water_cors[iter] = cc_wat

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting:
               IF (KEYWORD_SET(scatterplot) AND $
                  (cc_wat GT current_max_water_cc)) THEN BEGIN
                  current_max_water_cc = cc_wat
                  best_source_water_databuf = source_databuf
               ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  water values wherever they are both available:
               res = LINFIT(source_wat_data, target_wat_data, CHISQR = chi, $
                  PROB = prob, /DOUBLE)
               best_water_as[iter] = res[0]
               best_water_bs[iter] = res[1]
               best_water_chisqs[iter] = chi
               best_water_probs[iter] = prob

   ;  Consider the case where there are no common valid water pixel values:
            ENDIF ELSE BEGIN
               best_water_rsmds[iter] = 1.0E10
               best_water_cors[iter] = 0.0
               best_water_as[iter] = 0.0
               best_water_bs[iter] = 0.0
               best_water_chisqs[iter] = 1.0E10
               best_water_probs[iter] = 0.0
            ENDELSE
         ENDIF

   ;  === Statistics for cloud patches ===

         IF (n_masks EQ 3) THEN BEGIN
            IF (n_cld_pts GT 0) THEN BEGIN

   ;  Extract the cloud values wherever the source and the target are both
   ;  available:
               source_cld_data = source_databuf[kdx_cld]
               target_cld_data = target_databuf[kdx_cld]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target cloud values wherever they are both available:
               numer = TOTAL((source_cld_data - target_cld_data) * $
                  (source_cld_data - target_cld_data))
               rmsd = SQRT(numer / n_cld_pts)
               best_cloud_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  cloud values wherever they are both available:
               cc = CORRELATE(source_cld_data, target_cld_data, /DOUBLE)
               cc_cld = FLOAT(cc)
               best_cloud_cors[iter] = cc_cld

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting:
               IF (KEYWORD_SET(scatterplot) AND $
                  (cc_cld GT current_max_cloud_cc)) THEN BEGIN
                  current_max_cloud_cc = cc_cld
                  best_source_cloud_databuf = source_databuf
               ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  cloud values wherever they are both available:
               res = LINFIT(source_cld_data, target_cld_data, CHISQR = chi, $
                  PROB = prob, /DOUBLE)
               best_cloud_as[iter] = res[0]
               best_cloud_bs[iter] = res[1]
               best_cloud_chisqs[iter] = chi
               best_cloud_probs[iter] = prob
   ;  Consider the case where there are no common valid cloud pixel values:
            ENDIF ELSE BEGIN
               best_cloud_rsmds[iter] = 1.0E10
               best_cloud_cors[iter] = 0.0
               best_cloud_as[iter] = 0.0
               best_cloud_bs[iter] = 0.0
               best_cloud_chisqs[iter] = 1.0E10
               best_cloud_probs[iter] = 0.0
            ENDELSE
         ENDIF

         iter = iter + 1

      ENDFOR
   ENDFOR

   ;  Sort the Pearson correlation coefficient arrays in descending order:
   idx_lnd_sorted = REVERSE(SORT(best_land_cors))
   IF (n_masks GE 2) THEN idx_wat_sorted = REVERSE(SORT(best_water_cors))
   IF (n_masks EQ 3) THEN idx_cld_sorted = REVERSE(SORT(best_cloud_cors))

   ;  Reorder the contents of the output structure arrays to rank them in order
   ;  of decreasing correlation coefficient:
   best_land_cams = best_land_cams[idx_lnd_sorted]
   best_land_bnds = best_land_bnds[idx_lnd_sorted]
   best_land_npts = best_land_npts[idx_lnd_sorted]
   best_land_rsmds = best_land_rsmds[idx_lnd_sorted]
   best_land_cors = best_land_cors[idx_lnd_sorted]
   best_land_as = best_land_as[idx_lnd_sorted]
   best_land_bs = best_land_bs[idx_lnd_sorted]
   best_land_chisqs = best_land_chisqs[idx_lnd_sorted]
   best_land_probs = best_land_probs[idx_lnd_sorted]

   IF (n_masks GE 2) THEN BEGIN
      best_water_cams = best_water_cams[idx_wat_sorted]
      best_water_bnds = best_water_bnds[idx_wat_sorted]
      best_water_npts = best_water_npts[idx_wat_sorted]
      best_water_rsmds = best_water_rsmds[idx_wat_sorted]
      best_water_cors = best_water_cors[idx_wat_sorted]
      best_water_as = best_water_as[idx_wat_sorted]
      best_water_bs = best_water_bs[idx_wat_sorted]
      best_water_chisqs = best_water_chisqs[idx_wat_sorted]
      best_water_probs = best_water_probs[idx_wat_sorted]
   ENDIF

   IF (n_masks EQ 3) THEN BEGIN
      best_cloud_cams = best_cloud_cams[idx_cld_sorted]
      best_cloud_bnds = best_cloud_bnds[idx_cld_sorted]
      best_cloud_npts = best_cloud_npts[idx_cld_sorted]
      best_cloud_rsmds = best_cloud_rsmds[idx_cld_sorted]
      best_cloud_cors = best_cloud_cors[idx_cld_sorted]
      best_cloud_as = best_cloud_as[idx_cld_sorted]
      best_cloud_bs = best_cloud_bs[idx_cld_sorted]
      best_cloud_chisqs = best_cloud_chisqs[idx_cld_sorted]
      best_cloud_probs = best_cloud_probs[idx_cld_sorted]
   ENDIF

   ;  Define the output structure to contain all required resuklts:
   title = 'Best fits results'
   best_fits = CREATE_STRUCT('Title', title)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandCameras', best_land_cams)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandBands', best_land_bnds)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandNpts', best_land_npts)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandRMSDs', best_land_rsmds)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandCors', best_land_cors)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandAs', best_land_as)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandBs', best_land_bs)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandChisqs', best_land_chisqs)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandProbs', best_land_probs)

   IF (n_masks GT 1) THEN BEGIN
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterCameras', best_water_cams)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterBands', best_water_bnds)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterNpts', best_water_npts)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterRMSDs', best_water_rsmds)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterCors', best_water_cors)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterAs', best_water_as)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterBs', best_water_bs)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterChisqs', best_water_chisqs)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterProbs', best_water_probs)
   ENDIF

   IF (n_masks GT 2) THEN BEGIN
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudCameras', best_cloud_cams)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudBands', best_cloud_bnds)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudNpts', best_cloud_npts)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudRMSDs', best_cloud_rsmds)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudCors', best_cloud_cors)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudAs', best_cloud_as)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudBs', best_cloud_bs)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudChisqs', best_cloud_chisqs)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudProbs', best_cloud_probs)
   ENDIF

   ;  Generate and save the scatterplots for the best land, ocean and cloud
   ;  fits, if requested and if data are available for these target types:
   IF (KEYWORD_SET(scatterplot)) THEN BEGIN
      set_min_scatt = '0.0'

   ;  === Scatterplots for land masses ===

      IF (best_land_npts[0] GT 0) THEN BEGIN

   ;  Set the title of the scatterplot:
         CASE n_masks OF
            1: title_lnd = 'Scatterplot for the best linear fit over Block'
            2: title_lnd = 'Scatterplot for the best linear fit over land'
            3: title_lnd = 'Scatterplot for the best linear fit over clear land'
         ENDCASE

   ;  Set the title of the X axis for the best land source data channel:
         source_title_lnd = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + best_land_cams[0] + ' ' + best_land_bnds[0]

   ;  Set the title of the Y axis for the land target data channel:
         target_title_lnd = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + target_cam  + ' ' + target_bnd

         CASE n_masks OF
            1: prefix_lnd = 'Bestfits_Nm' + strstr(n_masks) + '_All_'
            2: prefix_lnd = 'Bestfits_Nm' + strstr(n_masks) + '_Lnd_'
            3: prefix_lnd = 'Bestfits_Nm' + strstr(n_masks) + '_ClL_'
         ENDCASE

   ;  Generate the scatterplot:
         rc = plt_scatt_gen(best_source_land_databuf[kdx_lnd], $
            source_title_lnd, $
            target_databuf[kdx_lnd], $
            target_title_lnd, $
            title_lnd, $
            pob_str, $
            misr_mode, $
            NPTS = best_land_npts[0], $
            RMSD = best_land_rsmds[0], $
            CORRCOEFF = best_land_cors[0], $
            LIN_COEFF_A = best_land_as[0], $
            LIN_COEFF_B = best_land_bs[0], $
            CHISQR = best_land_chisqs[0], $
            PROB = best_land_probs[0], $
            SET_MIN_SCATT = set_min_scatt, $
            PREFIX = prefix_lnd, $
            VERBOSE = verbose, $
            DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         IF ((debug) AND (rc NE 0)) THEN BEGIN
            error_code = 510
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF

   ;  === Scatterplots for water bodies ===

      IF (n_masks GE 2) THEN BEGIN
         IF (best_water_npts[0] GT 0) THEN BEGIN

   ;  Set the title of the scatterplot:
            CASE n_masks OF
               2: title_wat = 'Scatterplot for the best linear fit over water'
               3: title_wat = 'Scatterplot for the best linear fit over ' + $
                  'clear water'
               ELSE: BREAK
            ENDCASE


   ;  Set the title of the X axis for the best water source data channel:
            source_title_wat = 'L1B2 BRF ' + misr_mode + ' ' + $
               pob_str_space + ' ' + best_water_cams[0] + ' ' + $
               best_water_bnds[0]

   ;  Set the title of the Y axis for the water target data channel:
            target_title_wat = 'L1B2 BRF ' + misr_mode + ' ' + $
               pob_str_space + ' ' + target_cam  + ' ' + target_bnd

            CASE n_masks OF
               2: prefix_wat = 'Bestfits_Nm' + strstr(n_masks) + '_Wat_'
               3: prefix_wat = 'Bestfits_Nm' + strstr(n_masks) + '_ClW_'
               ELSE: BREAK
            ENDCASE


   ;  Generate the scatterplot:
            rc = plt_scatt_gen(best_source_water_databuf[kdx_wat], $
               source_title_wat, $
               target_databuf[kdx_wat], $
               target_title_wat, $
               title_wat, $
               pob_str, $
               misr_mode, $
               NPTS = best_water_npts[0], $
               RMSD = best_water_rsmds[0], $
               CORRCOEFF = best_water_cors[0], $
               LIN_COEFF_A = best_water_as[0], $
               LIN_COEFF_B = best_water_bs[0], $
               CHISQR = best_water_chisqs[0], $
               PROB = best_water_probs[0], $
               SET_MIN_SCATT = set_min_scatt, $
               PREFIX = prefix_wat, $
               VERBOSE = verbose, $
               DEBUG = debug, $
               EXCPT_COND = excpt_cond)
            IF ((debug) AND (rc NE 0)) THEN BEGIN
               error_code = 520
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDIF
      ENDIF

   ;  === Scatterplots for cloud patches ===

      IF (n_masks EQ 3) THEN BEGIN
         IF (best_cloud_npts[0] GT 0) THEN BEGIN

   ;  Set the title of the scatterplot:
            title_cld = 'Scatterplot for the best linear fit over clouds'

   ;  Set the title of the X axis for the best cloud source data channel:
            source_title_cld = 'L1B2 BRF ' + misr_mode + ' ' + $
               pob_str_space + ' ' + best_cloud_cams[0] + ' ' + $
               best_cloud_bnds[0]

   ;  Set the title of the Y axis for the cloud target data channel:
            target_title_cld = 'L1B2 BRF ' + misr_mode + ' ' + $
               pob_str_space + ' ' + target_cam  + ' ' + target_bnd

            prefix_cld = 'Bestfits_Nm' + strstr(n_masks) + '_Cloud_'

   ;  Generate the scatterplot:
            rc = plt_scatt_gen(best_source_cloud_databuf[kdx_cld], $
               source_title_cld, $
               target_databuf[kdx_cld], $
               target_title_cld, $
               title_cld, $
               pob_str, $
               misr_mode, $
               NPTS = best_cloud_npts[0], $
               RMSD = best_cloud_rsmds[0], $
               CORRCOEFF = best_cloud_cors[0], $
               LIN_COEFF_A = best_cloud_as[0], $
               LIN_COEFF_B = best_cloud_bs[0], $
               CHISQR = best_cloud_chisqs[0], $
               PROB = best_cloud_probs[0], $
               SET_MIN_SCATT = set_min_scatt, $
               PREFIX = prefix_cld, $
               VERBOSE = verbose, $
               DEBUG = debug, $
               EXCPT_COND = excpt_cond)
            IF ((debug) AND (rc NE 0)) THEN BEGIN
               error_code = 530
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   ;  Generate and save the log file, if requested:
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      fmt1 = '(A30, A)'
      fmt2 = '(2(A6, 2X), A6, 2X, 6(A12))'
      fmt3 = '(2(A6, 2X), I6, 2X, 6(F12.5))'
      log_fpath = root_dirs[3] + pob_str + '/L1B2_' + misr_mode + '/'
      rc = is_writable(log_fpath, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
         error_code = 540
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF (rc EQ -2) THEN FILE_MKDIR, log_fpath
      log_fname = 'Bestfits_Nmasks' + strstr(n_masks) + '_L1B2_BRF_' + $
         misr_mode + '_' + pob_str + '_' + misr_camera + '_' + $
         misr_band + '.txt'
      log_fspec = log_fpath + log_fname

      OPENW, log_unit, log_fspec, /GET_LUN
      PRINTF, log_unit, "File name: ", "'" + FILE_BASENAME(log_fspec) + $
         "'", FORMAT = fmt1
      PRINTF, log_unit, "Folder name: ", "'" + FILE_DIRNAME(log_fspec, $
         /MARK_DIRECTORY) + "'", FORMAT = fmt1
      PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Date of MISR acquisition: ', acquis_date, $
         FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Orbit: ', strstr(misr_orbit), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Block: ', strstr(misr_block), FORMAT = fmt1
      PRINTF, log_unit, 'Target Camera: ', misr_camera, FORMAT = fmt1
      PRINTF, log_unit, 'Target Band: ', misr_band, FORMAT = fmt1
      PRINTF, log_unit, 'Target Resolution: ', strstr(target_resol), $
         FORMAT = fmt1
      PRINTF, log_unit
      PRINTF, log_unit, 'Number of masks requested: ', strstr(n_masks), $
         FORMAT = fmt1
      PRINTF, log_unit

;  === Log results for land masses ===

      CASE n_masks OF
         1: PRINTF, log_unit, 'Results for all pixels:'
         2: PRINTF, log_unit, 'Results for land pixels:'
         3: PRINTF, log_unit, 'Results for clear land pixels:'
      ENDCASE
      PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
         'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
      PRINTF, log_unit, strrepeat('=', 96)
      FOR il = 0, N_ELEMENTS(best_land_cams) - 1 DO BEGIN
         PRINTF, log_unit, $
            best_land_cams[il], $
            best_land_bnds[il], $
            best_land_npts[il], $
            best_land_rsmds[il], $
            best_land_cors[il], $
            best_land_as[il], $
            best_land_bs[il], $
            best_land_chisqs[il], $
            best_land_probs[il], $
            FORMAT = fmt3
      ENDFOR
      PRINTF, log_unit

   ;  === Log results for water bodies areas ===

      CASE n_masks OF
         2: PRINTF, log_unit, 'Results for water pixels:'
         3: PRINTF, log_unit, 'Results for clear water pixels:'
         ELSE: BREAK
      ENDCASE
      IF (n_masks GE 2) THEN BEGIN
         PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
            'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
         PRINTF, log_unit, strrepeat('=', 96)
         FOR iw = 0, N_ELEMENTS(best_water_cams) - 1 DO BEGIN
            PRINTF, log_unit, $
               best_water_cams[iw], $
               best_water_bnds[iw], $
               best_water_npts[iw], $
               best_water_rsmds[iw], $
               best_water_cors[iw], $
               best_water_as[iw], $
               best_water_bs[iw], $
               best_water_chisqs[iw], $
               best_water_probs[iw], $
               FORMAT = fmt3
         ENDFOR
         PRINTF, log_unit
      ENDIF

   ;  === Log results for cloud areas ===

      IF (n_masks EQ 3) THEN BEGIN
         PRINTF, log_unit, 'Results for cloud pixels:'
         PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
            'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
         PRINTF, log_unit, strrepeat('=', 96)
         FOR iw = 0, N_ELEMENTS(best_cloud_cams) - 1 DO BEGIN
            PRINTF, log_unit, $
               best_cloud_cams[iw], $
               best_cloud_bnds[iw], $
               best_cloud_npts[iw], $
               best_cloud_rsmds[iw], $
               best_cloud_cors[iw], $
               best_cloud_as[iw], $
               best_cloud_bs[iw], $
               best_cloud_chisqs[iw], $
               best_cloud_probs[iw], $
               FORMAT = fmt3
         ENDFOR
      ENDIF

      PRINTF, log_unit
      PRINT, 'The log file has been saved in ' + log_fspec
      CLOSE, log_unit
      FREE_LUN, log_unit
   ENDIF

   RETURN, return_code

END
