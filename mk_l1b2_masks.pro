FUNCTION mk_l1b2_masks, $
   misr_ptr, $
   radrd_ptr, $
   n_masks, $
   lwc_mask_ptr, $
   AGP_FOLDER = agp_folder, $
   AGP_VERSION = agp_version, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   RCCM_FOLDER = rccm_folder, $
   RCCM_VERSION = rccm_version, $
   MAP_IT = map_it, $
   MAP_FOLDER = map_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates and saves on the heap a set of 36
   ;  output masks of the spatial distribution of geophysical media in the
   ;  scene, one for each camera and spectral band, for the selected MISR
   ;  MODE, PATH, ORBIT and BLOCK area. The number and nature of these
   ;  media is controlled by the input positional parameter n_masks, which
   ;  can only take the values 1, 2 or 3, as described below. These masks
   ;  are provided at the same spatial resolution as the original MISR
   ;  L1B2 Global Mode GRP data products.
   ;
   ;  ALGORITHM: This function defines a pointer array lwc_mask_ptr[9, 4]
   ;  where each element points to an array containing a mask dimensioned
   ;  either [512, 128] or [2048, 512], depending on the spatial
   ;  resolution of the corresponding MISR L1B2 GRP data product, and
   ;  taking on the following values:
   ;
   ;  *   IF (n_masks EQ 1), the 36 output masks attribute all observable
   ;      areas to land (1B), while areas obscured by topography or
   ;      belonging to the edges of the BLOCK are reported as 253B and
   ;      254B, respectively.
   ;
   ;  *   IF (n_masks EQ 2), the 36 output masks defined above (for
   ;      n_masks EQ 1) are updated to attribute the value 2B to all
   ;      observable water bodies (oceans and deep inland water), as
   ;      reported in the AGP data file for the specified BLOCK.
   ;
   ;  *   IF (n_masks EQ 3), the 36 output masks defined above (for
   ;      n_masks EQ 2) are further updated to attribute the value 3B to
   ;      all observable areas occupied by cloud fields in the RCCM data
   ;      product for the same PATH, ORBIT, BLOCK and CAMERA area.
   ;
   ;  SYNTAX: rc = mk_l1b2_masks(misr_ptr, radrd_ptr, $
   ;  n_masks, lwc_mask_ptr, $
   ;  AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;  RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
   ;  MAP_IT = map_it, MAP_FOLDER = map_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_ptr {POINTER} [I]: The pointer to a STRING array containing
   ;      metadata on the MISR MODE, PATH, ORBIT, BLOCK and VERSION to be
   ;      processed.
   ;
   ;  *   radrd_ptr {POINTER array} [I]: The array of 36 (9 cameras by 4
   ;      spectral bands) pointers to the UINT data buffers containing the
   ;      L1B2 Georectified Radiance Product (GRP) scaled radiance values
   ;      (with the RDQI attached), in the native order (DF to DA and Blue
   ;      to NIR).
   ;
   ;  *   n_masks {INT} [I]: The number of target types that need to be
   ;      discriminated by the masks: 1 to generate a single mask for all
   ;      geophysical target types, 2 to generate masks separately for
   ;      land masses and water bodies, or 3 to generate masks separately
   ;      for clear land masses, clear water bodies and cloud fields.
   ;
   ;  *   lwc_mask_ptr {POINTER array} [O]: The array of 36 (9 cameras by
   ;      4 spectral bands) pointers to the BYTE masks containing the
   ;      information on the spatial distribution of geophysical media to
   ;      consider, as defined by n_masks.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AGP_FOLDER = agp_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR AGP files, if they are not located in the
   ;      default location.
   ;
   ;  *   AGP_VERSION = agp_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The AGP version identifier to use instead
   ;      of the default value.
   ;
   ;  *   L1B2GM_FOLDER = l1b2gm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 GM files, if they are not located in
   ;      the default location. This keyword only needs to be provided (1)
   ;      when processing Local Mode data AND (2) when the L1B2 GRP data
   ;      are not accessible from the default location.
   ;
   ;  *   L1B2GM_VERSION = l1b2gm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 GM version identifier to use
   ;      instead of the default value. This keyword only needs to be
   ;      provided (1) when processing Local Mode data AND (2) when the
   ;      L1B2 GRP data are not accessible from the default location.
   ;
   ;  *   RCCM_FOLDER = rccm_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR RCCM files, if they are not located in the
   ;      default location.
   ;
   ;  *   RCCM_VERSION = rccm_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The MISR RCCM version identifier to use
   ;      instead of the default value.
   ;
   ;  *   MAP_IT = map_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating maps of the numerical results; this
   ;      currently generates only the RCCM maps.
   ;
   ;  *   MAP_FOLDER = map_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the maps.
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
   ;      lwc_mask_ptr points to the 36 masks for the specified inputs.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter lwc_mask_ptr may be
   ;      undefined, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 120: The input positional parameter radrd_ptr is not a
   ;      pointer array.
   ;
   ;  *   Error 130: The input positional parameter n_masks is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in orbit2date.pro.
   ;
   ;  *   Error 400: The directory map_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in
   ;      mk_water_land_masks.pro.
   ;
   ;  *   Error 510: An exception condition occurred in fix_rccm.pro.
   ;
   ;  *   Error 520: An exception condition occurred in fix_rccm.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   fix_rccm.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   heap_l1b2_block.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_pointer.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   make_bytemap.pro
   ;
   ;  *   mk_water_land_masks.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strcat.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   str2block.pro
   ;
   ;  *   str2orbit.pro
   ;
   ;  *   str2path.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function generates the output masks at the same
   ;      spatial resolution as the MISR L1B2 Global Mode databuffers,
   ;      even though the AGP and the RCCM inputs are only available at
   ;      the reduced spatial resolution, in order to report the obscured
   ;      area at the full spatial resolution whenever possible.
   ;
   ;  *   NOTE 2: If this function is called as part of processing Local
   ;      Mode data, the output masks of the non-red data channels in the
   ;      off-nadir cameras must subsequently be upscaled explicitly to
   ;      the full spatial resolution.
   ;
   ;  *   NOTE 3: If maps are required, the reduced spatial resolution
   ;      masks will be upscaled to the same size as the full spatial
   ;      resolution masks with the function lr2hr to facilitate
   ;      comparisons.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_block = 113
   ;      IDL> rc = find_l1b2gm_files(misr_path, misr_orbit, l1b2gm_files, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> rc = heap_l1b2_block(l1b2_files, misr_block, misr_ptr, $
   ;         radrd_ptr, rad_ptr, brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> n_masks = 3
   ;      IDL> rc = mk_l1b2_masks(misr_ptr, radrd_ptr, n_masks, lwc_mask_ptr, $
   ;         AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
   ;         RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
   ;         MAP_IT = map_it, MAP_FOLDER = map_folder, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc, ' excpt_cond = >' + excpt_cond + '<'
   ;      rc =        0 excpt_cond = ><
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
   ;  VERSIONING:
   ;
   ;  *   2018–08–27: Version 0.8 — Initial release.
   ;
   ;  *   2018–09–19: Version 0.9 — Update the code to use the most
   ;      current version of the function make_cloud_masks.pro.
   ;
   ;  *   2018–09–26: Version 1.0 — Initial public release.
   ;
   ;  *   2019–01–26: Version 1.1 — Update and complement a full set of
   ;      input keyword parameters, update the documentation.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–06: Version 2.11 — Update the function to generate 36
   ;      masks instead of 9, and save those on the heap; change the name
   ;      of this function from mk_l1b2_mask.pro to mk_l1b2_masks.pro.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–09–25: Version 2.1.1 — Update the code to use the latest
   ;      version of fix_rccm.pro and to modify the default map output
   ;      directory.
   ;
   ;  *   2019–10–24: Version 2.1.2 — Update the documentation to clarify
   ;      the fact that the output masks are always generated at the
   ;      spatial resolution of Global Mode L1B2 databuffers. Masks for
   ;      the non-red off-nadir data channels should be upscaled after
   ;      calling this function when processing Local Mode data.
   ;
   ;  *   2020–03–26: Version 2.1.3 — Update the code to generate the
   ;      masks required to process Local Mode L1B2 data: this implied
   ;      adding the optional keyword L1B2GM_FOLDER and L1B2GM_VERSION to
   ;      the function’s parameters list, and calling the function
   ;      heap_l1b2_block.pro; update the documentation.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
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
   IF (KEYWORD_SET(map_it)) THEN map_it = 1 ELSE map_it = 0
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
            ' positional parameter(s): misr_ptr, radrd_ptr, n_masks, ' + $
            'lwc_mask.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_ptr' is not a pointer:
      IF (is_pointer(misr_ptr) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter misr_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'radrd_ptr' is not a pointer array:
      IF ((is_pointer(radrd_ptr) NE 1) OR (is_array(radrd_ptr) NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter radrd_ptr is not a ' + $
            'pointer array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_masks' is invalid:
      IF ((n_masks LT 1) OR (n_masks GT 3)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter n_masks is invalid.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   bnds = misr_specs.BandNames

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

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Retrieve the MISR Mode, Path, Orbit, Block and Version identifiers:
   temp = *misr_ptr
   misr_mode = temp[0]
   misr_path_str = temp[1]
   misr_orbit_str = temp[2]
   misr_block_str = temp[3]
   misr_version = temp[4]

   pob_str = strcat([misr_path_str, misr_orbit_str, misr_block_str], '-')
   mpob_str = strcat([misr_mode, pob_str], '-')

   ;  Retrieve the numerical values of the MISR Path, Orbit, Block:
   rc = str2path(misr_path_str, misr_path)
   rc = str2orbit(misr_orbit_str, misr_orbit)
   rc = str2block(misr_block_str, misr_block)

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  ========== Processing for n_masks GT 0 (all cases) ==========

   ;  Define the output arrays of pointers to the L1B2 masks, one for each
   ;  camera and spectral band:
   lwc_mask_ptr = PTRARR(9, 4)

   ;  If maps are required, set the color convention and the output folder:
   IF (map_it) THEN BEGIN
      good_vals = [0B, 1B, 2B, 3B, 253B, 254B]
      good_vals_cols = ['red', 'green', 'blue', 'white', 'yellow', 'black']
      IF (KEYWORD_SET(map_folder)) THEN BEGIN
         rc = force_path_sep(map_folder, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         map_fpath = map_folder
      ENDIF ELSE BEGIN
         map_fpath = root_dirs[3] + pob_str + PATH_SEP() + $
            misr_mode + PATH_SEP() + 'L1B2' + PATH_SEP() + $
            'Maps_Masks' + PATH_SEP()
      ENDELSE

   ;  Check that the output directory 'map_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(map_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory map_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Loop over the camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Loop over the spectral bands:
      FOR bnd = 0, n_bnds - 1 DO BEGIN

   ;  Initialize the mask to report land in the entire Block:
         IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
            lwc_mask = MAKE_ARRAY(512, 128, TYPE = 1, VALUE = 1B)
         ENDIF ELSE BEGIN
            lwc_mask = MAKE_ARRAY(2048, 512, TYPE = 1, VALUE = 1B)
         ENDELSE

   ;  Retrieve the scaled radiances in the current spectral band of the current
   ;  camera:
         band = *radrd_ptr[cam, bnd]

   ;  Count and locate the obscured pixels in the current camera/band, and
   ;  update the current mask if needed:
         idx_obsc = WHERE((band EQ 65511U), n_obsc)
         IF (n_obsc GT 0) THEN lwc_mask[idx_obsc] = 253B

   ;  Count and locate the edge pixels in the current camera/band, and
   ;  update the current mask if needed:
         idx_edg = WHERE((band EQ 65515U), n_edge)
         IF (n_edge GT 0) THEN lwc_mask[idx_edg] = 254B

   ;  Store this array on the heap:
         lwc_mask_ptr[cam, bnd] = PTR_NEW(lwc_mask)

   ;  Save a map if required:
         IF (map_it) THEN BEGIN
            map_fname = 'Map_L1B2_mask_nm1_' + mpob_str + '-' + $
               cams[cam] + '-' + bnds[bnd] + '_' + $
               acquis_date + '_' + date + '.png'
            map_fspec = map_fpath + map_fname
            IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
               mask = lr2hr(lwc_mask)
            ENDIF ELSE BEGIN
               mask = lwc_mask
            ENDELSE
            rc = make_bytemap(mask, good_vals, good_vals_cols, $
               map_fspec, DEBUG = debug, EXCPT_COND = excpt_cond)
         ENDIF
      ENDFOR
   ENDFOR

   IF (verbose GT 0) THEN PRINT, 'Done land mask.'

   ;  ========== Processing for n_masks GT 1 ==========

   ;  Retrieve the simplified land and water masks as specified by the static
   ;  AGP file for this Block:
   IF (n_masks GT 1) THEN BEGIN
      misr_resol = 1100
      rc = mk_water_land_masks(misr_path, misr_block, misr_resol, $
         water_mask, land_mask, $
         AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 500
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Generate the equivalent high spatial resolution water mask:
      water_mask_hr = lr2hr(water_mask)

   ;  Reset the lwc_masks to include the water bodies:
   ;  Loop over the camera files:
      FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Loop over the spectral bands:
         FOR bnd = 0, n_bnds - 1 DO BEGIN
            lwc_mask = *lwc_mask_ptr[cam, bnd]
            IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
               wdx = WHERE((water_mask EQ 1B) AND (lwc_mask LT 4B), count_w)
            ENDIF ELSE BEGIN
               wdx = WHERE((water_mask_hr EQ 1B) AND (lwc_mask LT 4B), count_w)
            ENDELSE
            IF (count_w GT 0) THEN BEGIN
               lwc_mask[wdx] = 2B
            ENDIF

   ;  Store this array back on the heap:
            lwc_mask_ptr[cam, bnd] = PTR_NEW(lwc_mask)

   ;  Save a map if required:
            IF (map_it) THEN BEGIN
               map_fname = 'Map_L1B2_mask_nm2_' + mpob_str + '-' + $
                  cams[cam] + '-' + bnds[bnd] + '_' + $
                  acquis_date + '_' + date + '.png'
               map_fspec = map_fpath + map_fname
               IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
                  mask = lr2hr(lwc_mask)
               ENDIF ELSE BEGIN
                  mask = lwc_mask
               ENDELSE
               rc = make_bytemap(mask, good_vals, good_vals_cols, $
                  map_fspec, DEBUG = debug, EXCPT_COND = excpt_cond)
            ENDIF
         ENDFOR
      ENDFOR

      IF (verbose GT 0) THEN PRINT, 'Done water mask.'

   ENDIF

   ;  ========== Processing for n_masks GT 2 ==========

   ;  Retrieve the upgraded RCCM:
   IF (n_masks GT 2) THEN BEGIN

   ;  Whenever processing Local Mode data, load the Global Mode L1B2 GRP data
   ;  for the same Path, Orbit and Block on the heap for the purpose of
   ;  correcting the RCCM data product:
      IF (misr_mode EQ 'LM') THEN BEGIN
         misr_gm_mode = 'GM'
         rc = heap_l1b2_block(misr_gm_mode, misr_path, misr_orbit, misr_block, $
            misr_gm_ptr, radrd_gm_ptr, rad_gm_ptr, brf_gm_ptr, rdqi_gm_ptr, $
            scalf_gm_ptr, convf_gm_ptr, $
            L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
            L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
            MISR_SITE = misr_site, TEST_ID = test_id, $
            FIRST_LINE = first_line, LAST_LINE = last_line, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)

         rc = fix_rccm(misr_gm_ptr, radrd_gm_ptr, rccm, $
            RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
            TEST_ID = test_id, FIRST_LINE = first_line, LAST_LINE = last_line, $
            LOG_IT = log_it, LOG_FOLDER = log_folder, $
            SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
            MAP_IT = map_it, MAP_FOLDER = map_folder, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 510
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF ELSE BEGIN

         rc = fix_rccm(misr_ptr, radrd_ptr, rccm, $
            RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
            TEST_ID = test_id, FIRST_LINE = first_line, LAST_LINE = last_line, $
            LOG_IT = log_it, LOG_FOLDER = log_folder, $
            SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
            MAP_IT = map_it, MAP_FOLDER = map_folder, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 520
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDELSE

   ;  Reset the lwc_masks to include the water bodies:
   ;  Loop over the camera files:
      FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Generate the equivalent high spatial resolution cloud mask:
         cloud_mask = REFORM(rccm[cam, *, *])
         cloud_mask_hr = lr2hr(cloud_mask)

   ;  Loop over the spectral bands:
         FOR bnd = 0, n_bnds - 1 DO BEGIN
            lwc_mask = *lwc_mask_ptr[cam, bnd]
            IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
               wdx = WHERE(((cloud_mask EQ 1B) OR (cloud_mask EQ 2B)) $
                  AND (lwc_mask LT 4B), count_c)
            ENDIF ELSE BEGIN
               wdx = WHERE(((cloud_mask_hr EQ 1B) OR (cloud_mask_hr EQ 2B)) $
                  AND (lwc_mask LT 4B), count_c)
            ENDELSE
            IF (count_c GT 0) THEN BEGIN
               lwc_mask[wdx] = 3B
            ENDIF

   ;  Store this array back on the heap:
            lwc_mask_ptr[cam, bnd] = PTR_NEW(lwc_mask)

   ;  Save a map if required:
            IF (map_it) THEN BEGIN
               map_fname = 'Map_L1B2_mask_nm3_' + mpob_str + '-' + $
                  cams[cam] + '-' + bnds[bnd] + '_' + $
                  acquis_date + '_' + date + '.png'
               map_fspec = map_fpath + map_fname
               IF ((cam NE 4) AND (bnd NE 2)) THEN BEGIN
                  mask = lr2hr(lwc_mask)
               ENDIF ELSE BEGIN
                  mask = lwc_mask
               ENDELSE
               rc = make_bytemap(mask, good_vals, good_vals_cols, $
                  map_fspec, DEBUG = debug, EXCPT_COND = excpt_cond)
            ENDIF
         ENDFOR
      ENDFOR

      IF (verbose GT 0) THEN PRINT, 'Done cloud mask.'

   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
