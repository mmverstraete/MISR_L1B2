FUNCTION map_l1b2_block, misr_mode, misr_path, misr_orbit, misr_block, $
   SCL_RGB_MIN = scl_rgb_min, SCL_RGB_MAX = scl_rgb_max, $
   SCL_NIR_MIN = scl_nir_min, SCL_NIR_MAX = scl_nir_max, $
   RGB_LOW = rgb_low, RGB_HIGH = rgb_high, PER_BAND = per_band, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates and saves RGB composite and,
   ;  optionally, black and white maps of MISR L1B2 Georectified Radiance
   ;  Product (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance
   ;  files of the specified MISR MODE for each of the 9 cameras and for a
   ;  full BLOCK of a given PATH and ORBIT. If the PER_BAND keyword is
   ;  set, each of the 4 spectral bands is mapped in black and white at
   ;  the high (275 m) spatial resolution, where low spatial resolution
   ;  fields are upsized by duplication as required. This program also
   ;  creates a log file to ensure the repeatability and traceability of
   ;  these outcomes.
   ;
   ;  ALGORITHM: This function maps the specified MISR L1B2 Georectified
   ;  Radiance Product (GRP) Terrain-Projected Top of Atmosphere (ToA)
   ;  Radiance files of the specified MISR MODE using the following
   ;  options:
   ;
   ;  *   Minimum and maximum scalings can be provided to stretch the
   ;      images and highlight (or hide) features as needed. Different
   ;      scaling settings can be provided to treat visible and NIR
   ;      channels differently; default values are in place if these
   ;      keywords are not set (0.0 to 0.35 and 0.0 to 0.50,
   ;      respectively).
   ;
   ;  *   To ease subsequent comparisons with MISR-HR L1B3 products, all
   ;      GLOBAL MODE maps are generated as if data were available at the
   ;      full native spatial resolution (275 m) of MISR, which can be
   ;      achieved in two ways:
   ;
   ;      -   If the RGB_LOW keyword is set, the high-resolution channel
   ;          (typically the red band for each off-nadir camera) is
   ;          spatially averaged to 1.1 km (similar to the on-board
   ;          compression of non-red channels), and all 3 visible channels
   ;          are upsized to full spatial resolution by duplication before
   ;          generating the map.
   ;
   ;      -   If the RGB_HIGH keyword is set, the low-resolution channels
   ;          (typically the non-red band for each off-nadir camera) are
   ;          first upsized by duplication to match the 275 m resolution
   ;          of the red channel before generating the map.
   ;
   ;  *   If the PER_BAND keyword is set, it applies to all cameras and
   ;      forces the generation of a Black and White map for each spectral
   ;      band individually.
   ;
   ;  SYNTAX:
   ;  rc = map_l1b2_block(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  SCL_RGB_MIN = scl_rgb_min, SCL_RGB_MAX = scl_rgb_max, $
   ;  SCL_NIR_MIN = scl_nir_min, SCL_NIR_MAX = scl_nir_max, $
   ;  RGB_LOW = rgb_low, RGB_HIGH = rgb_high, PER_BAND = per_band, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   SCL_RGB_MIN = scl_rgb_min {FLOAT} [I] (Default value: 0.0):
   ;      The smallest unscaled L1B2 GRP ToA radiance to be mapped in the
   ;      visible (RGB) spectral channels.
   ;
   ;      -   If set to -1, the minimum scaling for each of the 3 RGB
   ;          channels will be set to the minimum non-zero value found in
   ;          those channels (actual stretching).
   ;
   ;      -   If set to 0 (or not set), the minimum scaling for each of
   ;          the 3 RGB channels will be set to 0.0 (standard stretching).
   ;
   ;      -   If set to a positive value, the minimum scaling for each of
   ;          the 3 RGB channels will be set to the indicated value
   ;          (specified stretching).
   ;
   ;  *   SCL_RGB_MAX = scl_rgb_max {FLOAT} [I] (Default value: 0.35):
   ;      The largest unscaled L1B2 GRP ToA radiance to be mapped in the
   ;      visible (RGB) spectral channels.
   ;
   ;      -   If set to -1, the maximum scaling for each of the 3 RGB
   ;          channels will be set to the maximum non-zero value found in
   ;          those channels (actual stretching).
   ;
   ;      -   If set to 0 (or not set), the maximum scaling for each of
   ;          the 3 RGB channels will be set to 0.35 (standard
   ;          stretching).
   ;
   ;      -   If set to a positive value, the maximum scaling for each of
   ;          the 3 RGB channels will be set to the indicated value
   ;          (specified stretching).
   ;
   ;  *   SCL_NIR_MIN = scl_nir_min {FLOAT} [I] (Default value: 0.0):
   ;      The smallest unscaled L1B2 GRP ToA radiance to be mapped in the
   ;      NIR spectral channel.
   ;
   ;      -   If set to -1, the minimum scaling for the NIR channel will
   ;          be set to the minimum non-zero value found in that channel
   ;          (actual stretching).
   ;
   ;      -   If set to 0 (or not set), the minimum scaling for the NIR
   ;          channel will be set to 0.0 (standard stretching).
   ;
   ;      -   If set to a positive value, the minimum scaling for the NIR
   ;          channel will be set to the indicated value (specified
   ;          stretching).
   ;
   ;  *   SCL_NIR_MAX = scl_nir_max {FLOAT} [I] (Default value: 0.50):
   ;      The largest unscaled L1B2 GRP ToA radiance to be mapped in the
   ;      NIR spectral channel.
   ;
   ;      -   If set to -1, the maximum scaling for the NIR channel will
   ;          be set to the maximum non-zero value found in that channel
   ;          (actual stretching).
   ;
   ;      -   If set to 0 (or not set), the maximum scaling for the NIR
   ;          channel will be set to 0.5 (standard stretching).
   ;
   ;      -   If set to a positive value, the maximum scaling for the NIR
   ;          channel will be set to the indicated value (specified
   ;          stretching).
   ;
   ;  *   RGB_LOW = rgb_low {INTEGER} [I] (Default value: 1): If set (for
   ;      Global Mode data, and for off-nadir pointing cameras only), this
   ;      keyword requests that the RED spectral channel be averaged first
   ;      to 1.1 km and that the resulting RGB map be upsized to 275 m by
   ;      replicating pixel values.
   ;
   ;  *   RGB_HIGH = rgb_high {INTEGER} [I] (Default value: 0): If set
   ;      (for Global Mode data, and for off-nadir pointing cameras only),
   ;      this keyword requests that the non-RED spectral channels be
   ;      upsized first to 275 m by replicating pixel values before
   ;      generating the RGB map.
   ;
   ;  *   PER_BAND = per_band {INTEGER} [I] (Default value: 0): If set
   ;      (for all cameras), this keyword requests that data from each of
   ;      the available spectral bands be mapped separately in black and
   ;      white. All maps are generated at the full spatial resolution,
   ;      where the Global Mode fields available only at the low
   ;      resolution are upsized by duplication.
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
   ;      provided in the call.
   ;      If the input positional parameters point to a Global Mode file,
   ;      this function generates and saves 72 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_GM/’:
   ;
   ;      -   1 plain text log file describing the inputs and outputs to
   ;          this function, named
   ;          map-log_Pxxx_Oyyyyyy_Bzzz_L1B2_GM_toabrf_[acquis_date]_
   ;          [MISR-Version]_[creation_date].txt.
   ;
   ;      -   1 PNG file containing the RGB composite map for the AN
   ;          camera (high-res channels only), named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_AN_toabrf-rgb-275_[acquis_date]_
   ;          [MISR-Version]_[creation_date].png.
   ;
   ;      -   4 PNG files containing the B&W maps of the individual
   ;          spectral bands of the AN camera (high-res channels only),
   ;          named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_AN_toabrf-[band_name]-275_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   8 PNG files containing the RGB composite maps for each of
   ;          the 8 off-nadir cameras, where the red channel is downsized
   ;          to 1100 m before all pixels are duplicated to 275 m, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-rgb-mixed-low_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   8 PNG files containing the RGB composite maps for each of
   ;          the 8 off-nadir cameras, where the blue and green channels
   ;          are upsized to 275 m to generate the map, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-rgb-mixed-high_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   8 PNG files containing the B&W maps for each high-resolution
   ;          L1B2 data channel of the off-nadir cameras in the red
   ;          spectral band, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-Red-275_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   24 PNG files containing the B&W maps for each low-resolution
   ;          L1B2 data channel of the off-nadir cameras in the blue,
   ;          green and NIR spectral bands, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-[band_name]
   ;          -1100_[acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   9 PNG files containing the colorbars associated with the
   ;          individual data channels in the visible spectral bands
   ;          (blue, green, red) in each camera, named
   ;          map-colbar_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-VIS_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   9 PNG files containing the colorbars associated with the
   ;          individual data channels in the NIR spectral band in each
   ;          camera, named
   ;          map-colbar_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_toabrf-NIR_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      If the input positional parameters point to a Local Mode file,
   ;      this function generates and saves 64 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_LM/’:
   ;
   ;      -   1 plain text log file describing the inputs and outputs to
   ;          this function, named
   ;          map-log_Pxxx_Oyyyyyy_Bzzz_L1B2_LM_toabrf_[acquis_date]_
   ;          [MISR-Version]_[creation_date].txt.
   ;
   ;      -   1 PNG file containing the RGB composite map for each of the
   ;          9 MISR cameras, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_LM_[camera]_toabrf-rgb-275_[acquis_date]_
   ;          [MISR-Version]_[creation_date].png.
   ;
   ;      -   4 PNG files containing the B&W maps of the individual
   ;          spectral bands for each of the 9 MISR cameras, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2_LM_[camera]_toabrf-[band_name]-275_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   9 PNG files containing the colorbars associated with the
   ;          individual data channels in the visible spectral bands
   ;          (blue, green, red) in each camera, named
   ;          map-colbar_Pxxx_Oyyyyyy_Bzzz_L1B2_LM_[camera_name]_toabrf-VIS_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;      -   9 PNG files containing the colorbars associated with the
   ;          individual data channels in the NIR spectral band in each
   ;          camera, named
   ;          map-colbar_Pxxx_Oyyyyyy_Bzzz_L1B2_LM_[camera_name]_toabrf-NIR_
   ;          [acquis_date]_[MISR-Version]_[creation_date].png.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The maps and colorbars are not generated.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_path is invalid.
   ;
   ;  *   Error 120: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 130: Input argument misr_block is invalid.
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
   ;  *   Error 250: An exception condition occurred in function
   ;      get_l1b2_files: Either too few or too many L1B2 GRP ToA radiance
   ;      files of the specified MODE were found (9 are expected).
   ;
   ;  *   Error 260: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 270: An exception condition occurred in function
   ;      is_writable.pro.
   ;
   ;  *   Error 280: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_VERSION.
   ;
   ;  *   Error 310: An exception condition occurred in function hr2lr.pro
   ;      when downsizing the red data channel.
   ;
   ;  *   Error 320: An exception condition occurred in function lr2hr.pro
   ;      when upscaling the red data channel.
   ;
   ;  *   Error 330: An exception condition occurred in function lr2hr.pro
   ;      when upscaling the green data channel.
   ;
   ;  *   Error 340: An exception condition occurred in function lr2hr.pro
   ;      when upscaling the blue data channel.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   get_l1b2_files.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   is_dir.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: *** WARNING ***: This routine assigns fixed names to the
   ;      various maps generated for a given combination of MISR PATH,
   ;      ORBIT and BLOCK. If it must be executed multiple times with
   ;      different options, rename or move the results in a different
   ;      location to avoid overwriting the maps with newer results.
   ;
   ;  *   NOTE 2: This routine currently does not check whether the input
   ;      file actually contains data for the specified Block.
   ;
   ;  *   NOTE 3: The input L1B2 GRP ToA radiance files will be expected
   ;      in the directory root_dirs[1] + ’/Pxxx/L1_[misr_mode]’ where
   ;      root_dirs[1] is defined by the function set_root_dirs.pro and
   ;      must exist before this routine is executed.
   ;
   ;  *   NOTE 4: The maps and log file will be saved in the output
   ;      directory root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_[misr_mode]
   ;      where root_dirs[3] is defined by the function set_root_dirs.pro;
   ;      if this directory does not exist it is created.
   ;
   ;  *   NOTE 5: The same scl_rgb_min and scl_rgb_max values are used for
   ;      all 3 RGB spectral channels, whether maps are generated in color
   ;      or in black and white; separate values scl_nir_min and
   ;      scl_nir_max are provided to map the NIR spectral channel. If one
   ;      or more of these keywords is set to  − 1, the image stretchings
   ;      can vary between cameras.
   ;
   ;  *   NOTE 6: All maps created by this routine are generated at the
   ;      full spatial resolution (2048 × 512) pixels; low resolution
   ;      pixels are duplicated as needed.
   ;
   ;  *   NOTE 7: The optional keywords RGB_LOW, RGB_HIGH, and PER_BAND
   ;      are non exclusive. If none of these keywords is set, then
   ;      RGB_LOW is presumed to be requested.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = map_l1b2_block(168, 68050, 110, $
   ;         /RGB_LOW, /RGB_HIGH, /PER_BAND, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2012–11–23: Version 0.5 — Initial release by Linda Hunt (as
   ;      l1b2_maps.pro).
   ;
   ;  *   2017–03–15: Version 0.8 — Provide similar but enhanced
   ;      functionality (option to specify different scaling factors for
   ;      the visible (RGB) and NIR spectral channels, all 4 MISR spectral
   ;      bands are mapped with the /PER_BAND option), include extended
   ;      diagnostics, feature expanded in-line documentation, and
   ;      generate a log file as well as colorbar legends for the B&W maps
   ;      in the designated output directory.
   ;
   ;  *   2017–07–19: Version 0.9 — Routine implemented as a function
   ;      (rather than a program), allow scaling keywords to take -1
   ;      values for optimal stretching, adds the EXCPT_COND keyword, and
   ;      update the documentation.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–04–08: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–05–02: Version 1.3 — Merge this function with its twin
   ;      map_l1b2_lm.pro and change the name to map_l1b2_block.pro.
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
         IF (N_PARAMS() NE n_reqs) THEN BEGIN
            error_code = 100
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Routine must be called with ' + strstr(n_reqs) + $
               ' positional parameters: misr_mode, misr_path, misr_orbit, ' + $
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
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Identify the current computer:
   SPAWN, 'hostname -s', computer
   computer = computer[0]

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()
   IF ((debug) AND (root_dirs[0] EQ 'Unrecognized computer')) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Unrecognized computer.'
      RETURN, error_code
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

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

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Identify the 9 L1B2 input files to map:
   ;  WARNING: This code fragment will prevent the generation of any map if the
   ;  number of L1B2 files is different from 9.
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_files = N_ELEMENTS(l1b2_files)

   ;  Set the designated Block as the region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Define the standard directory in which to save the maps and the log file:
   local_path = pob_str + PATH_SEP() + 'L1B2_' + misr_mode + PATH_SEP()
   map_path = root_dirs[3] + local_path

   ;  Return to the calling routine with an error message if the output
   ;  directory 'map_path' is not writable, and create it if it does not
   ;  exist:
   rc = is_writable(map_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, map_path

   ;  Retrieve the version number of the first MISR L1B2 file available,
   ;  assuming all files were generated with the same software version as the
   ;  first one:
   status = MTK_FILE_VERSION(l1b2_files[0], misr_version)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_FILE_VERSION = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Generate the specification of the log file:
   log_fname = 'map-log_' + pob_str + '_L1B2_' + misr_mode + '_toabrf_' + $
      acquis_date + '_' + misr_version + '_' + date + '.txt'
   log_fspec = map_path + log_fname
   fmt1 = '(A30, A)'

   ;  Open the log file and start recording events:
   OPENW, log_unit, log_fspec, /GET_LUN
   PRINTF, log_unit, "File name: ", "'" + log_fname + "'", FORMAT = fmt1
   PRINTF, log_unit, "Folder name: ", $
      root_dirs[3] + "'" + local_path + "'", FORMAT = fmt1
   PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, log_unit, 'Generated  on: ', computer, FORMAT = fmt1
   PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
   PRINTF, log_unit

   PRINTF, log_unit, 'Date of MISR acquisition: ' + acquis_date
   PRINTF, log_unit

   IF (misr_mode EQ 'GM') THEN BEGIN
      PRINTF, log_unit, 'Content: Log file created in conjunction with ' + $
         'the generation of the following'
      PRINTF, log_unit, '71 L1B2 GRP Terrain-projected ToA ' + misr_mode + $
         ' BRF maps and colorbars:'
      PRINTF, log_unit, ''
      PRINTF, log_unit, '   * 1 RGB map for the L1B2 AN camera,'
      PRINTF, log_unit, '   * 4 B&W maps for the L1B2 AN camera,'
      PRINTF, log_unit, '   * 8 RGB maps for the L1B2 (red downsized),'
      PRINTF, log_unit, '   * 8 RGB maps for the L1B2 (non-red upsized),'
      PRINTF, log_unit, '   * 8 B&W maps for the L1B2 off-nadir red channels,'
      PRINTF, log_unit, '   * 24 B&W maps for each low-resolution L1B2,'
      PRINTF, log_unit, '   * 9 colorbars for the VIS channels, and'
      PRINTF, log_unit, '   * 9 colorbars for the NIR channels.'
      PRINTF, log_unit
   ENDIF
   IF (misr_mode EQ 'LM') THEN BEGIN
      PRINTF, log_unit, 'Content: Log file created in conjunction with ' + $
         'the generation of the following'
      PRINTF, log_unit, '63 L1B2 GRP Terrain-projected ToA ' + misr_mode + $
         ' BRF maps and colorbars:'
      PRINTF, log_unit, ''
      PRINTF, log_unit, '   * 1 RGB map for each of the 9 L1B2 cameras,'
      PRINTF, log_unit, '   * 4 B&W maps for each of the 9 L1B2 cameras,'
      PRINTF, log_unit, '   * 9 colorbars for the VIS channels, and'
      PRINTF, log_unit, '   * 9 colorbars for the NIR channels.'
      PRINTF, log_unit
   ENDIF

   PRINTF, log_unit
   PRINTF, log_unit, 'Input L1B2 directory: ' + $
      FILE_DIRNAME(l1b2_files[0], /MARK_DIRECTORY)
   PRINTF, log_unit, 'misr_mode  = ' + misr_mode
   PRINTF, log_unit, 'misr_path  = ' + misr_path_str
   PRINTF, log_unit, 'misr_orbit = ' + misr_orbit_str
   PRINTF, log_unit, 'misr_block = ' + misr_block_str
   PRINTF, log_unit, 'misr_version = ' + misr_version
   PRINTF, log_unit, 'Output directory: ' + map_path
   PRINTF, log_unit

   ;  Set the default set of maps for Global Mode input data:
   IF (misr_mode EQ 'GM') THEN BEGIN
      IF ((~KEYWORD_SET(rgb_low)) AND $
      (~KEYWORD_SET(rgb_high)) AND $
      (~KEYWORD_SET(per_band))) THEN rgb_low = 1

      PRINTF, log_unit, 'Mapping options (GM files):'
      IF (KEYWORD_SET(rgb_low)) THEN PRINTF, log_unit, $
         '   Option rgb_low has been requested.' ELSE PRINTF, log_unit, $
         '   Option rgb_low has not been requested.'
      IF (KEYWORD_SET(rgb_high)) THEN PRINTF, log_unit, $
         '   Option rgb_high has been requested.' ELSE PRINTF, log_unit, $
         '   Option rgb_high has not been requested.'
      IF (KEYWORD_SET(per_band)) THEN PRINTF, log_unit, $
         '   Option per_band has been requested.' ELSE PRINTF, log_unit, $
         '   Option per_band has not been requested.'
      PRINTF, log_unit
   ENDIF ELSE BEGIN
      PRINTF, log_unit, 'Mapping options (LM files):'
      IF (KEYWORD_SET(per_band)) THEN PRINTF, log_unit, $
         '   Option per_band has been requested.' ELSE PRINTF, log_unit, $
         '   Option per_band has not been requested.'
      PRINTF, log_unit
   ENDELSE

   ;  *** WARNING ***: The array rgb_bands is specifically dimensioned to
   ;  generate RGB maps. Treat the NIR band spectral data separately, because
   ;  it requires different stretchings.

   ;  Name the RGB spectral bands. Note that the order of the spectral bands
   ;  here is different from the standard order [Blue, Green, Red, NIR]:
   rgb_bands = ['Red', 'Green', 'Blue']
   map_fname1 = 'map_' + pob_str + '_L1B2_' + misr_mode + '_'
   map_fname2 = acquis_date + '_' + misr_version + '_' + date + '.png'

   ;  Iterate over the 9 MISR L1B2 files:
   FOR i = 0, n_files - 1 DO BEGIN

   ;  Read the spectral data from the current file (i.e., for a given camera):
      status1 = MTK_READDATA(l1b2_files[i], 'BlueBand', 'Blue BRF', $
         region, blue, mapinfo)
      status2 = MTK_READDATA(l1b2_files[i], 'GreenBand', 'Green BRF', $
         region, green, mapinfo)
      status3 = MTK_READDATA(l1b2_files[i], 'RedBand', 'Red BRF', $
         region, red, mapinfo)
      status4 = MTK_READDATA(l1b2_files[i], 'NIRBand', 'NIR BRF', $
         region, nir, mapinfo)

   ;  Verify that those data fields were correctly read:
      IF ((debug) AND ((status1 NE 0) OR (status2 NE 0) OR (status3 NE 0) OR $
         (status4 NE 0))) THEN BEGIN
         PRINTF, log_unit, 'Warning:'
         PRINTF, log_unit, '   One or more of the spectral data channels ' + $
            'for Block ' + misr_block_str + ' was not read correctly in file'
         PRINTF, log_unit, '   ' + FILE_BASENAME(l1b2_files[i])
         PRINTF, log_unit, 'status1 = ' + strstr(status1) + $
            ', status2 = ' + strstr(status2) + $
            ', status3 = ' + strstr(status3) + $
            ', status4 = ' + strstr(status4)
         PRINTF, log_unit, $
            'File skipped. The corresponding maps will be missing.'
         PRINTF, log_unit
         CONTINUE
      ENDIF

   ;  Determine the camera name for the current file name:
      parts = STRSPLIT(FILE_BASENAME(l1b2_files[i]), '_', /EXTRACT)
      cam = parts[7]
      PRINTF, log_unit, 'Mapping fields of Camera ' + cam
      PRINTF, log_unit, '---------------------------'
      PRINTF, log_unit

   ;  Compute the minimum and maximum valid (non-zero) BRF values found in
   ;  each spectral band:
      idx = WHERE(blue GT 0.0, n_gud_blue)
      IF (n_gud_blue GT 0) THEN BEGIN
         min_blue = MIN(blue[idx])
         max_blue = MAX(blue[idx])
      ENDIF ELSE BEGIN
         min_blue = 0.0
         max_blue = 1.0
      ENDELSE

      idx = WHERE(green GT 0.0, n_gud_green)
      IF (n_gud_green GT 0) THEN BEGIN
         min_green = MIN(green[idx])
         max_green = MAX(green[idx])
      ENDIF ELSE BEGIN
         min_green = 0.0
         max_green = 1.0
      ENDELSE

      idx = WHERE(red GT 0.0, n_gud_red)
      IF (n_gud_red GT 0) THEN BEGIN
         min_red = MIN(red[idx])
         max_red = MAX(red[idx])
      ENDIF ELSE BEGIN
         min_red = 0.0
         max_red = 1.0
      ENDELSE

      idx = WHERE(nir GT 0.0, n_gud_nir)
      IF (n_gud_nir GT 0) THEN BEGIN
         min_nir = MIN(nir[idx])
         max_nir = MAX(nir[idx])
      ENDIF ELSE BEGIN
         min_nir = 0.0
         max_nir = 1.0
      ENDELSE

      fmt2 = '(A21, A)'
      PRINTF, log_unit, 'Minima and maxima in each spectral channel:'
      PRINTF, log_unit, 'min_red = ', strstr(min_red), FORMAT = fmt2
      PRINTF, log_unit, 'max_red = ', strstr(max_red), FORMAT = fmt2
      PRINTF, log_unit, 'min_green = ', strstr(min_green), FORMAT = fmt2
      PRINTF, log_unit, 'max_green = ', strstr(max_green), FORMAT = fmt2
      PRINTF, log_unit, 'min_blue = ', strstr(min_blue), FORMAT = fmt2
      PRINTF, log_unit, 'max_blue = ', strstr(max_blue), FORMAT = fmt2
      PRINTF, log_unit, 'min_nir = ', strstr(min_nir), FORMAT = fmt2
      PRINTF, log_unit, 'max_nir = ', strstr(max_nir), FORMAT = fmt2
      PRINTF, log_unit

   ;  Manage the scaling factors for this camera:
      IF (KEYWORD_SET(scl_rgb_min)) THEN BEGIN
         IF (scl_rgb_min EQ -1) THEN BEGIN
            scl_rgb_min_eff = MIN([min_blue, min_green, min_red])
            scl_rgb_min_opt = ' (Actual stretching).'
         ENDIF ELSE BEGIN
            scl_rgb_min_eff = scl_rgb_min
            scl_rgb_min_opt = ' (Specified stretching).'
         ENDELSE
      ENDIF ELSE BEGIN
         scl_rgb_min_eff = 0.0
         scl_rgb_min_opt = ' (Default stretching).'
      ENDELSE

      IF (KEYWORD_SET(scl_rgb_max)) THEN BEGIN
         IF (scl_rgb_max EQ -1) THEN BEGIN
            scl_rgb_max_eff = MAX([max_blue, max_green, max_red])
            scl_rgb_max_opt = ' (Actual stretching).'
         ENDIF ELSE BEGIN
            scl_rgb_max_eff = scl_rgb_max
            scl_rgb_max_opt = ' (Specified stretching).'
         ENDELSE
      ENDIF ELSE BEGIN
         scl_rgb_max_eff = 0.35
         scl_rgb_max_opt = ' (Default stretching).'
      ENDELSE

      IF (KEYWORD_SET(scl_nir_min)) THEN BEGIN
         IF (scl_nir_min EQ -1) THEN BEGIN
            scl_nir_min_eff = min_nir
            scl_nir_min_opt = ' (Actual stretching).'
         ENDIF ELSE BEGIN
            scl_nir_min_eff = scl_nir_min
            scl_nir_min_opt = ' (Specified stretching).'
         ENDELSE
      ENDIF ELSE BEGIN
         scl_nir_min_eff = 0.0
         scl_nir_min_opt = ' (Default stretching).'
      ENDELSE

      IF (KEYWORD_SET(scl_nir_max)) THEN BEGIN
         IF (scl_nir_max EQ -1) THEN BEGIN
            scl_nir_max_eff = max_nir
            scl_nir_max_opt = ' (Actual stretching).'
         ENDIF ELSE BEGIN
            scl_nir_max_eff = scl_nir_max
            scl_nir_max_opt = ' (Specified stretching).'
         ENDELSE
      ENDIF ELSE BEGIN
         scl_nir_max_eff = 0.50
         scl_nir_max_opt = ' (Default stretching).'
      ENDELSE

      PRINTF, log_unit, 'Effective scaling factors used for camera ' + cam + $
         ':'
      PRINTF, log_unit, 'For the 3 visible spectral channels:'
      PRINTF, log_unit, '   scl_rgb_min_eff = ' + strstr(scl_rgb_min_eff) + $
         scl_rgb_min_opt
      PRINTF, log_unit, '   scl_rgb_max_eff = ' + strstr(scl_rgb_max_eff) + $
         scl_rgb_max_opt
      PRINTF, log_unit, 'For the NIR spectral channel:'
      PRINTF, log_unit, '   scl_nir_min_eff = ' + strstr(scl_nir_min_eff) + $
         scl_nir_min_opt
      PRINTF, log_unit, '   scl_nir_max_eff = ' + strstr(scl_nir_max_eff) + $
         scl_nir_max_opt
      PRINTF, log_unit

   ;  Get the dimensions of the red spectral band data set (which is always
   ;  available at the full spatial resolution):
      sz = SIZE(red, /DIMENSIONS)

   ;  If the input data is available from a Local Mode file, or from the AN
   ;  camera of a Global Mode file, all 3 spectral data fields are already at
   ;  the full spatial resolution, so the RGB map can be created immediately:
      cam = STRUPCASE(cam)
      IF ((misr_mode EQ 'LM') OR (cam EQ 'AN')) THEN BEGIN
         img_dat = FLTARR(3, sz[0], sz[1])
         img_dat[0, *, *] = red
         img_dat[1, *, *] = green
         img_dat[2, *, *] = blue
         img = BYTSCL(img_dat, MIN = scl_rgb_min_eff, MAX = scl_rgb_max_eff)

   ;  Set the name of this RGB map file:
         map_fspec = map_path + $
            map_fname1 + $
            cam + '_toabrf-rgb-275_' + $
            map_fname2

   ;  Save the RGB map:
         WRITE_PNG, map_fspec, img, /ORDER
         PRINTF, log_unit, '   - Saved the RGB map in ' + $
            FILE_BASENAME(map_fspec)

   ;  Generate the B&W maps for these 3 same individual red, green and blue
   ;  spectral bands if they have also been requested:
         IF KEYWORD_SET(per_band) THEN BEGIN
            FOR b = 0, N_ELEMENTS(rgb_bands) - 1 DO BEGIN
               img = BYTSCL(img_dat[b, *, *], scl_rgb_min_eff, scl_rgb_max_eff)

   ;  Set the name of this individual band map file:
               map_fspec = map_path + $
                  map_fname1 + $
                  cam + '_toabrf-' + $
                  rgb_bands[b] + '-275_' + $
                  map_fname2

   ;  Save each of the B&W maps for the 3 RGB band of this camera:
               WRITE_PNG, map_fspec, img, /ORDER
               PRINTF, log_unit, '   - Saved the B&W map for band ' + $
                  rgb_bands[b] + ' in ' + FILE_BASENAME(map_fspec)
            ENDFOR

   ;  Generate the NIR map separately, using the NIR-specific scaling:
            img = BYTSCL(nir, scl_nir_min_eff, scl_nir_max_eff)
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-NIR-275_' + $
               map_fname2
            WRITE_PNG, map_fspec, img, /ORDER
            PRINTF, log_unit, '   - Saved the B&W map for band ' + $
               'NIR in ' + FILE_BASENAME(map_fspec)
         ENDIF
      ENDIF ELSE BEGIN

   ;  Handle Global Mode off-nadir cameras, where the spatial resolution of
   ;  the non-red spectral channels is 1100 m instead of 275 m, and the red
   ;  channel is downsized to 1100 m before all pixels are duplicated to 275 m
   ;  format display purposes:
         IF KEYWORD_SET(RGB_LOW) THEN BEGIN
            image_low = FLTARR(3, sz[0], sz[1])
            lowres_red = hr2lr(red, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               error_code = 310
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
            image_low[0, *, *] = lr2hr(lowres_red, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               error_code = 320
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF

            image_low[1, *, *] = lr2hr(green, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               error_code = 330
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF

            image_low[2, *, *] = lr2hr(blue, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               error_code = 340
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF

            img_low = BYTSCL(image_low, MIN = scl_rgb_min_eff, $
               MAX = scl_rgb_max_eff)

   ;  Set the name of the RGB-Low off-nadir map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-rgb-mixed-low_' + $
               map_fname2

   ;  Save the RGB-Low off-nadir map:
            WRITE_PNG, map_fspec, img_low, /ORDER
            PRINTF, log_unit, '   - Saved the low-resolution RGB map ' + $
               'for camera ' + cam + ' in ' + FILE_BASENAME(map_fspec)
         ENDIF

   ;  Handle Global Mode off-nadir cameras, where the spatial resolution of
   ;  the non-red spectral channels is 1100 m instead of 275 m, and the non-red
   ;  channels are upized to 275 m by duplication before creating the map:
         IF KEYWORD_SET(RGB_HIGH) THEN BEGIN
            image_high = FLTARR(3, sz[0], sz[1])
            image_high[0, *, *] = red
            image_high[1, *, *] = lr2hr(green, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            image_high[2, *, *] = lr2hr(blue, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            img_high = BYTSCL(image_high, MIN = scl_rgb_min_eff, $
               MAX = scl_rgb_max_eff)

   ;  Set the name of the RGB-High off-nadir map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-rgb-mixed-high_' + $
               map_fname2

   ;  Save the RGB-High off-nadir map:
            WRITE_PNG, map_fspec, img_high, /ORDER
            PRINTF, log_unit, '   - Saved the mixed-resolution RGB map ' + $
               'for camera ' + cam + ' in ' + FILE_BASENAME(map_fspec)
         ENDIF

   ;  Generate the maps for the individual bands if they have also been
   ;  requested, distinguishing between the red band at the full spatial
   ;  resolution and the other 3 bands at the reduced spatial resolution.
         IF KEYWORD_SET(per_band) THEN BEGIN

   ;  First, do the Red band (always at high resolution):
            img = BYTSCL(red, MIN = scl_rgb_min_eff, MAX = scl_rgb_max_eff)

   ;  Set the name of the Red band map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-Red-275_' + $
               map_fname2

            WRITE_PNG, map_fspec, img, /ORDER
            PRINTF, log_unit, '   - Saved the high-resolution B&W map ' + $
               'for camera ' + cam + ' and band Red in ' + $
               FILE_BASENAME(map_fspec)

   ;  Do the Green band (always at low resolution):
            img = BYTSCL(lr2hr(green), MIN = scl_rgb_min_eff, $
               MAX = scl_rgb_max_eff)

   ;  Set the name of the Green band map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-Green-1100_' + $
               map_fname2

            WRITE_PNG, map_fspec, img, /ORDER
            PRINTF, log_unit, '   - Saved the high-resolution B&W map ' + $
               'for camera ' + cam + ' and band Green in ' + $
               FILE_BASENAME(map_fspec)

   ;  Do the Blue band (always at low resolution):
            img = BYTSCL(lr2hr(blue), MIN = scl_rgb_min_eff, $
               MAX = scl_rgb_max_eff)

   ;  Set the name of the Blue band map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-Blue-1100_' + $
               map_fname2

            WRITE_PNG, map_fspec, img, /ORDER
            PRINTF, log_unit, '   - Saved the high-resolution B&W map ' + $
               'for camera ' + cam + ' and band Blue in ' + $
               FILE_BASENAME(map_fspec)

   ;  Do the NIR band (always at low resolution):
            img = BYTSCL(lr2hr(nir), MIN = scl_nir_min_eff, $
               MAX = scl_nir_max_eff)

   ;  Set the name of the NIR band map file:
            map_fspec = map_path + $
               map_fname1 + $
               cam + '_toabrf-NIR-1100_' + $
               map_fname2

            WRITE_PNG, map_fspec, img, /ORDER
            PRINTF, log_unit, '   - Saved the high-resolution B&W map ' + $
               'for camera ' + cam + ' and band NIR in ' + $
               FILE_BASENAME(map_fspec)
         ENDIF
      ENDELSE
      PRINTF, log_unit

   ;  Generate the colorbar legends to interpret the B&W visible and NIR maps
   ;  if they have been requested:
      IF KEYWORD_SET(per_band) THEN BEGIN
         w = WINDOW(DIMENSIONS = [400, 400])
         cb = COLORBAR(RANGE = [scl_rgb_min_eff, scl_rgb_max_eff], $
            TITLE = 'Gray scale for L1B2 VIS spectral maps from Cam ' + cam, $
            FONT_STYLE = 2, $
            POSITION = [0.5, 0.15, 0.6, 0.85], $
            RGB_TABLE = 0, $
            BORDER_ON = 1, $
            TAPER = 3, $
            ORIENTATION = 1)
         cb_fname1 = 'map-colbar_' + pob_str + '_L1B2_' + misr_mode + '_'
         cb_fname2 = acquis_date + '_' + misr_version + '_' + date + '.png'
         l1b2_vis_cb_fspec = map_path + $
            cb_fname1 + $
            cam + '_toabrf-VIS_' + $
            cb_fname2

         cb.Save, l1b2_vis_cb_fspec
         w.Close
         w = WINDOW(DIMENSIONS = [400, 400])
         cb = COLORBAR(RANGE = [scl_nir_min_eff, scl_nir_max_eff], $
            TITLE = 'Gray scale for L1B2 NIR spectral map from Cam ' + cam, $
            FONT_STYLE = 2, $
            POSITION = [0.5, 0.15, 0.6, 0.85], $
            RGB_TABLE = 0, $
            BORDER_ON = 1, $
            TAPER = 3, $
            ORIENTATION = 1)
         cb_fname1 = 'map-colbar_' + pob_str + '_L1B2_' + misr_mode + '_'
         cb_fname2 = acquis_date + '_' + misr_version + '_' + date + '.png'
         l1b2_nir_cb_fspec = map_path + $
            cb_fname1 + $
            cam + '_toabrf-NIR_' + $
            cb_fname2
         cb.Save, l1b2_nir_cb_fspec
         w.Close
      ENDIF
   ENDFOR

   FREE_LUN, log_unit
   CLOSE, /ALL

   RETURN, return_code
END
