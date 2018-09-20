FUNCTION make_l1b2_masks, misr_mode, misr_path, misr_orbit, misr_block, $
   n_masks, l1b2_masks, MAPS = maps, AGP_VERSION = agp_version, $
   L1B2_VERSION = l1b2_version, RCCM_VERSION = rccm_version, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates a set of 36 masks (one for each
   ;  camera and spectral band) to indicate the spatial distribution of
   ;  target types within the seleted MISR PATH, ORBIT and BLOCK area. All
   ;  masks are created at the full spatial resolution of the instrument
   ;  (275 m), and the nature of the target types being discriminated is
   ;  controlled by the input positional parameter n_masks.
   ;
   ;  ALGORITHM: The amount of processing performed by this function
   ;  depends on the value of the input positional parameter n_masks,
   ;  which can only take the values 1, 2 or 3:
   ;
   ;  *   IF (n_masks GT 0), the masks distinguish between edge, valid,
   ;      poor (RDQI = 2), bad (RDQI = 3) and obscured pixels.
   ;
   ;  *   IF (n_masks GT 1), the masks distinguish between edge, valid
   ;      land, valid water, poor (RDQI = 2), bad (RDQI = 3) and obscured
   ;      pixels, using the static information available in the relevant
   ;      AGP data file.
   ;
   ;  *   IF (n_masks GT 2), the masks distinguish between edge, valid
   ;      clear land, valid clear water, cloudy, poor (RDQI = 2), bad
   ;      (RDQI = 3) and obscured pixels, using the time-dependent
   ;      information available in the relevant RCCM data files.
   ;
   ;  SYNTAX:
   ;  rc = make_l1b2_masks(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  n_masks, l1b2_masks, MAPS = maps, AGP_VERSION = agp_version, $
   ;  L1B2_VERSION = l1b2_version, RCCM_VERSION = rccm_version, $
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
   ;  *   n_masks {INT} [I]: The index specifying which types of masks are
   ;      required.
   ;
   ;  *   l1b2_masks {BYTE array [9, 4, 2048, 512]} [O]: The MISR L1B2
   ;      masks, at the full spatial resolution, for the 9 cameras and 4
   ;      spectral bands.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   MAPS = maps {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) saving the maps of the masks.
   ;
   ;  *   AGP_VERSION = agp_version {STRING} [I] (Default value: ’F01_24’):
   ;      The AGP version identifier to use.
   ;
   ;  *   L1B2_VERSION = l1b2_version {STRING} [I] (Default value: ’F03_0024’):
   ;      The L1B2 version identifier to use.
   ;
   ;  *   RCCM_VERSION = rccm_version {STRING} [I] (Default value: ’F04_0025’):
   ;      The RCCM version identifier to use.
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
   ;      provided in the call. The output positional parameter array
   ;      l1b2_masks contains the 36 masks at the full spatial resolution
   ;      of the MISR instrument (275 m), one for each camera and spectral
   ;      band, where the pixel values have the following meanings:
   ;
   ;      -   IF (n_masks GT 0): The mask value of unobserved (e.g., edge)
   ;          pixels is 0B, the mask value of valid pixels is set to 1B,
   ;          the mask value of poor (RDQI = 2) pixels is set 253B, the
   ;          mask value of bad (RDQI = 3) pixels is set 254B, and the
   ;          mask value of pixels obscured by topography is set to 255B.
   ;
   ;      -   IF (n_masks GT 1): In addition to the categories recognized
   ;          with n_masks = 1, valid pixels are further partitioned as
   ;          land pixels, set to 1B, and water pixels, set to 2B.
   ;
   ;      -   IF (n_masks GT 2): In addition to the categories recognized
   ;          with n_masks = 1, valid pixels are further partitioned as
   ;          clear land pixels, set to 1B, clear water pixels, set to 2B,
   ;          and cloudy pixels, set to 3B.
   ;
   ;      If the input keyword parameter MAPS is set, mask maps are saved
   ;      in the folder
   ;      root_dirs[3] + pob_str + PATH_SEP() + ’L1B2_GM’ + PATH_SEP().
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter l1b2_masks and the
   ;      mask maps may be undefined, inexistent, incomplete or useless.
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
   ;  *   Error 150: Input positional parameter n_masks is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 230: Either none or more than one L1B2 files were found.
   ;
   ;  *   Error 240: An exception condition occurred in lr2hr.pro.
   ;
   ;  *   Error 250: An exception condition occurred in lr2hr.pro.
   ;
   ;  *   Error 260: An exception condition occurred in
   ;      make_water_mask.pro.
   ;
   ;  *   Error 270: An exception condition occurred in lr2hr.pro.
   ;
   ;  *   Error 280: An exception condition occurred in
   ;      make_cloud_masks.pro.
   ;
   ;  *   Error 290: An exception condition occurred in lr2hr.pro.
   ;
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 310: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_MAKE_FILENAME.
   ;
   ;  *   Error 320: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 330: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 500: An exception condition occurred in is_writable.pro.
   ;
   ;  *   Error 510: An exception condition occurred in make_bytemap.pro.
   ;
   ;  *   Error 520: An exception condition occurred in make_bytemap.pro.
   ;
   ;  *   Error 530: An exception condition occurred in make_bytemap.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   make_bytemap.pro
   ;
   ;  *   make_cloud_masks.pro
   ;
   ;  *   make_water_mask.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function generates MISR L1B2 masks at the full
   ;      spatial resolution of 275 m because these are needed to process
   ;      the high-resolution data channels of the L1B2 Global Mode or the
   ;      Local Mode files, and because the distribution of edge and
   ;      obscured pixels is resolution dependent. However, some of the
   ;      key inputs to create those masks (in particular the AGP and RCCM
   ;      files) are only available at the reduced spatial resolution:
   ;      these are upscaled as needed with the function lr2hr.pro.
   ;
   ;  *   NOTE 2: If the optional keyword parameter MAPS is set, this
   ;      functions saves 36, 72 or 108 mask maps when the input
   ;      positional parameter n_masks is set to 1, 2, or 3, respectively.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_block = 113
   ;      IDL> n_masks = 3
   ;      IDL> rc = make_l1b2_masks(misr_mode, misr_path, $
   ;         misr_orbit, misr_block, n_masks, l1b2_masks, $
   ;         /MAPS, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 excpt_cond = ><
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–27: Version 0.8 — Initial release.
   ;
   ;  *   2018–09–19: Version 0.9 — Update the code to use the current
   ;      version of function .
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
   IF (~KEYWORD_SET(maps)) THEN maps = 0 ELSE maps = 1
   IF (~KEYWORD_SET(agp_version)) THEN agp_version = 'F01_24'
   IF (~KEYWORD_SET(l1b2_version)) THEN l1b2_version = 'F03_0024'
   IF (~KEYWORD_SET(rccm_version)) THEN rccm_version = 'F04_0025'
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, misr_orbit, ' + $
            'misr_block, n_masks, l1b2_masks.'
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
   ;  positional parameter 'n_masks' is invalid:
      IF ((n_masks LT 1) OR (n_masks GT 3)) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter n_masks is invalid.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   num_cams = misr_specs.NCameras
   cam_names = misr_specs.CameraNames
   num_bnds = misr_specs.NBands
   bnd_names = misr_specs.BandNames

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  If maps have been required,
   IF (maps) THEN BEGIN

   ;  Generate the string version of the MISR Block number:
      rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str
   ENDIF

   ;  Define the output variable l1b2_masks:
   l1b2_masks = BYTARR(9, 4, 2048, 512)

   ;  ========== Processing for n_masks GT 0 (all cases) ==========

   ;  Initialize all mask values to 1 (land) in all 9 l1b2_masks:
   l1b2_masks[*, *, *, *] = 1B

   ;  Set the directory address of the folder containing the MISR L1B2 files:
   l1b2_path = root_dirs[1] + misr_path_str + PATH_SEP() + 'L1_' + $
      misr_mode + PATH_SEP()
   misr_product = 'GRP_TERRAIN_' + misr_mode

   ;  Define the (1-Block) region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Loop over the cameras:
   FOR cam = 0, num_cams - 1 DO BEGIN
      cam_name = cam_names[cam]

   ;  Generate the filename for the current camera:
      status = MTK_MAKE_FILENAME(l1b2_path, misr_product, cam_name, $
         STRMID(misr_path_str, 1), STRMID(misr_orbit_str, 1), $
         l1b2_version, f_spec)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_MAKE_FILENAME = ' + strstr(status)
         RETURN, error_code
      ENDIF

   ;  Ensure that name is unique and remove any remaining wildcard character:
      in_file = FILE_SEARCH(f_spec, COUNT = n_files)
      IF (debug AND (n_files NE 1)) THEN BEGIN
         error_code = 230
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Either none or more than one L1B2 files were found.'
         RETURN, error_code
      ENDIF
      l1b2_fspec = in_file[0]

   ;  Loop over the spectral bands of the current camera:
      FOR bnd = 0, num_bnds - 1 DO BEGIN
         bnd_name = bnd_names[bnd]

   ;  Read the scaled Radiance/RDQI and the RDQI fields:
         grid = bnd_name + 'Band'
         field = bnd_name + ' Radiance/RDQI'
         status = MTK_READDATA(l1b2_fspec, grid, field, region, rad, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 320
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': status from MTK_READDATA = ' + strstr(status)
            RETURN, error_code
         ENDIF
         field = bnd_name + ' RDQI'
         status = MTK_READDATA(l1b2_fspec, grid, field, region, rdqi, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 330
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': status from MTK_READDATA = ' + strstr(status)
            RETURN, error_code
         ENDIF

   ;  Determine the dimensions of the data buffers, and upscale them to the
   ;  full spatial resolution if necessary:
         dims = SIZE(rad, /DIMENSIONS)
         IF (dims[0] EQ 512) THEN BEGIN
            rad = lr2hr(rad, DEBUG = debug, EXCPT_COND = excpt_cond)
            IF (debug AND (excpt_cond NE '')) THEN BEGIN
               error_code = 240
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
            rdqi = lr2hr(rdqi, DEBUG = debug, EXCPT_COND = excpt_cond)
            IF (debug AND (excpt_cond NE '')) THEN BEGIN
               error_code = 250
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDIF

   ;  Determine which pixels have an RDQI of 2:
         idx_poor = WHERE(rdqi EQ 2, n_poor)

   ;  Determine which pixels have an RDQI of 3:
         idx_bad = WHERE(rdqi EQ 3, n_bad)

   ;  Determine which pixels are obscured by topography:
         idx_obsc = WHERE(rad EQ 65511, n_obsc)

   ;  Determine which pixels are never observed (edges):
         idx_edge = WHERE(rad EQ 65515, n_edge)

   ;  Extract the mask for the current camera and band:
         l1b2_mask = REFORM(l1b2_masks[cam, bnd, *, *])

   ;  Reset the value of the poor pixels in the mask to 253B:
         IF (n_poor GT 0) THEN l1b2_mask[idx_poor] = 253B

   ;  Reset the value of the bad pixels in the mask to 254B:
         IF (n_bad GT 0) THEN l1b2_mask[idx_bad] = 254B

   ;  Reset the value of the obscured pixels in the mask to 255B:
         IF (n_obsc GT 0) THEN l1b2_mask[idx_obsc] = 255B

   ;  Reset the value of the edge pixels in the mask to 0B:
         IF (n_edge GT 0) THEN l1b2_mask[idx_edge] = 0B

   ;  Reassign those updated values to the output variable l1b2_masks:
         l1b2_masks[cam, bnd, *, *] = l1b2_mask
      ENDFOR
   ENDFOR

   ;  Generate the maps, if required:
   IF (maps) THEN BEGIN
      maps_path = root_dirs[3] + pob_str + PATH_SEP() + 'L1B2_GM' + PATH_SEP()

   ;  Check that this folder is writable:
      rc = is_writable(maps_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
         error_code = 500
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF (rc EQ -2) THEN FILE_MKDIR, maps_path

      good_vals = [0B, 1B, 253B, 254B, 255B]
      good_vals_cols = ['black', 'green', 'orange', 'red', 'dark_gray']

   ;  Loops over cameras and spectral bands:
      FOR cam = 0, num_cams - 1 DO BEGIN
         FOR bnd = 0, num_bnds - 1 DO BEGIN

   ;  Generate the map file specification:
            maps_file = 'Map_mask_1_' + pob_str + '_' + cam_names[cam] + '_' + $
               bnd_names[bnd] + '.png'
            maps_spec = maps_path + maps_file

   ;  Generate the mask map:
            map = REFORM(l1b2_masks[cam, bnd, *, *])
            rc = make_bytemap(map, good_vals, good_vals_cols, $
               maps_spec, DEBUG = debug, EXCPT_COND = excpt_cond)
            IF (debug AND (rc NE 0)) THEN BEGIN
               error_code = 510
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDFOR
      ENDFOR
   ENDIF

   ;  ========== Processing for n_masks GT 1 ==========

   ;  If (n_masks GT 1), get the AGP water mask and initialize all mask values
   ;  to 2 (water) over those areas in all 9 l1b2_masks:
   IF (n_masks GT 1) THEN BEGIN
      rc = make_water_mask(misr_path, misr_block, water_mask, $
         AGP_VERSION = agp_version, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 260
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Count the number of water pixels:
      n_water = TOTAL(water_mask)

   ;  If there are any, upscale this water mask to match the spatial resolution
   ;  of the output argument l1b2_masks. Note: The following process could
   ;  result in no change in the output argument l1b2_masks if all dark water
   ;  bodies present in the Block are located in geographical areas covered by
   ;  edge fill values.
      IF (n_water GT 0) THEN BEGIN
         water_mask = lr2hr(water_mask, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (excpt_cond NE '')) THEN BEGIN
            error_code = 270
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF

   ;  Extract the existing mask for each camera and spectral band, and reset
   ;  its values to 2B where appropriate:
         FOR cam = 0, num_cams - 1 DO BEGIN
            FOR bnd = 0, num_bnds - 1 DO BEGIN

   ;  Determine where these dark water bodies are located (this is valid for
   ;  all cameras and bands). Note 1: The following WHERE statement needs to
   ;  be executed for each camera and band because the location of valid pixels
   ;  is generally different in each case. Note 2: The variable n_water may be
   ;  larger than n_wat because the AGP surface types are assigned throughout
   ;  the Block while the following WHERE statement only concerns valid L1B2
   ;  values:
               l1b2_mask = REFORM(l1b2_masks[cam, bnd, *, *])
               idx = WHERE(((water_mask EQ 1B) AND (l1b2_mask EQ 1B)), n_wat)
               l1b2_mask[idx] = 2B

   ;  Reassign those updated values to the output variable l1b2_masks in each
   ;  camera and band:
               l1b2_masks[cam, bnd, *, *] = l1b2_mask
            ENDFOR
         ENDFOR
      ENDIF
   ENDIF

   ;  Generate the maps, if required:
   IF (maps) THEN BEGIN
      good_vals = [0B, 1B, 2B, 253B, 254B, 255B]
      good_vals_cols=['black', 'green', 'blue', 'orange', 'red', 'dark_gray']

   ;  Loops over cameras and spectral bands:
      FOR cam = 0, num_cams - 1 DO BEGIN
         FOR bnd = 0, num_bnds - 1 DO BEGIN

   ;  Generate the map file specification:
            maps_file = 'Map_mask_2_' + pob_str + '_' + cam_names[cam] + '_' + $
               bnd_names[bnd] + '.png'
            maps_spec = maps_path + maps_file

   ;  Generate the mask map:
            map = REFORM(l1b2_masks[cam, bnd, *, *])
            rc = make_bytemap(map, good_vals, good_vals_cols, $
               maps_spec, /DEBUG, EXCPT_COND = excpt_cond)
            IF (debug AND (rc NE 0)) THEN BEGIN
               error_code = 520
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDFOR
      ENDFOR
   ENDIF

   ;  ========== Processing for n_masks GT 2 ==========

   ;  If (n_masks GT 2), get the RCCM cloud mask and initialize all mask values
   ;  to 3 (cloudy) over those areas in all 9 l1b2_masks:
   IF (n_masks GT 2) THEN BEGIN
      rc = make_cloud_masks(misr_mode, misr_path, misr_orbit, misr_block, $
         cloud_masks, rev_cloud_masks, L1B2_VERSION = l1b2_version, $
         RCCM_VERSION = rccm_version, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 280
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Count the number of cloud pixels in the revised cloud masks:
      idx = WHERE(((rev_cloud_masks EQ 1B) OR (rev_cloud_masks EQ 2B)), n_cloud)

   ;  If there are clouds in the scene:
      IF (n_cloud GT 0) THEN BEGIN

         FOR cam = 0, num_cams - 1 DO BEGIN
            cloud_mask = REFORM(rev_cloud_masks[cam, *, *])
            cloud_mask = lr2hr(cloud_mask, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF (debug AND (excpt_cond NE '')) THEN BEGIN
               error_code = 290
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                  ': ' + excpt_cond
               RETURN, error_code
            ENDIF
            FOR bnd = 0, num_bnds - 1 DO BEGIN
               l1b2_mask = REFORM(l1b2_masks[cam, bnd, *, *])
               idx = WHERE((((cloud_mask EQ 1B) OR (cloud_mask EQ 2B)) $
                  AND ((l1b2_mask EQ 1B) OR (l1b2_mask EQ 2B))), n_cld)
               l1b2_mask[idx] = 3B

   ;  Reassign those updated values to the output variable l1b2_masks in each
   ;  camera and band:
               l1b2_masks[cam, bnd, *, *] = l1b2_mask
            ENDFOR
         ENDFOR
      ENDIF
   ENDIF

   ;  Generate the maps, if required:
   IF (maps) THEN BEGIN
      good_vals=[0B, 1B, 2B, 3B]
      good_vals_cols=['red', 'green', 'blue', 'white']
      good_vals = [0B, 1B, 2B, 3B, 253B, 254B, 255B]
      good_vals_cols=['black', 'green', 'blue', 'white', 'orange', $
         'red', 'dark_gray']

   ;  Loops over cameras and spectral bands:
      FOR cam = 0, num_cams - 1 DO BEGIN
         FOR bnd = 0, num_bnds - 1 DO BEGIN

   ;  Generate the map file specification:
            maps_file = 'Map_mask_3_' + pob_str + '_' + cam_names[cam] + '_' + $
               bnd_names[bnd] + '.png'
            maps_spec = maps_path + maps_file

   ;  Generate the mask map:
            map = REFORM(l1b2_masks[cam, bnd, *, *])
            rc = make_bytemap(map, good_vals, good_vals_cols, $
               maps_spec, /DEBUG, EXCPT_COND = excpt_cond)
            IF (debug AND (rc NE 0)) THEN BEGIN
               error_code = 530
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDFOR
      ENDFOR
   ENDIF

   RETURN, return_code

END
