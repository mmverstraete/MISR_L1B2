FUNCTION fill_cloud_masks, misr_mode, misr_path, misr_orbit, misr_block, $
   rccm_cloud, rev_rccm_cloud, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates revised versions of the 9 original
   ;  RCCM cloud masks, where missing values are replaced by probable
   ;  estimates of the cloudiness at those locations. The codes for
   ;  non-missing values are left untouched.
   ;
   ;  ALGORITHM: This function inspects the 5 by 5 neighbors of each
   ;  missing pixel in each of the 9 MISR RCCM files specified by the
   ;  input positional parameters misr_mode, misr_path, misr_orbit,
   ;  misr_block, and replaces those missing values by probable estimates
   ;  of the cloudiness at those locations, based on the statistics of
   ;  their neighbors. In low confidence or ambiguous cases, the
   ;  retrievability of the standard land product is consulted to
   ;  determine whether the area is likely to be clear or cloudy.
   ;
   ;  SYNTAX: rc = fill_cloud_masks(misr_mode, misr_path, misr_orbit, $
   ;  misr_block, rccm_cloud, rev_rccm_cloud, $
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
   ;  *   rccm_cloud {BYTE array} [I]: The MISR RCCM cloud mask product.
   ;
   ;  *   rev_rccm_cloud {BYTE array} [O]: The revised RCCM cloud mask
   ;      product.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output positional parameter
   ;      rev_rccm_cloud contains the revised cloud mask, presumably with
   ;      fewer or no missing values. The pixels in this revised cloud
   ;      mask rev_rccm_cloud can take on the following values:
   ;
   ;      -   0: No retrieval (original RCCM assignment).
   ;
   ;      -   1: Cloud with high confidence (original RCCM assignment).
   ;
   ;      -   2: Cloud with low confidence (original RCCM assignment).
   ;
   ;      -   3: Clear with low confidence (original RCCM assignment).
   ;
   ;      -   4: Clear with high confidence (original RCCM assignment).
   ;
   ;      -   5: Missing pixel considered probably cloudy (as per this
   ;          function).
   ;
   ;      -   6: Missing pixel considered probably clear (as per this
   ;          function).
   ;
   ;      -   253: Missing pixel is not observed due to topography
   ;          obscuration.
   ;
   ;      -   254: Missing pixel is not observed because it is within the
   ;          eastern or western edges, i.e., outside the field of view of
   ;          the camera.
   ;
   ;      -   255: Original fill value -1 of the RCCM file.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter rev_rccm_cloud may be
   ;      undefined, inexistent, incomplete or useless.
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
   ;  *   Error 200: An exception condition occurred in
   ;      make_land_retr_mask.pro.
   ;
   ;  *   Error 210: An exception condition occurred in
   ;      make_rdqi_fill_masks.pro.
   ;
   ;  *   Error 220: An exception condition occurred in hr2lr.pro.
   ;
   ;  *   Error 230: An exception condition occurred in
   ;      make_rdqi_fill_masks.pro.
   ;
   ;  *   Error 240: An exception condition occurred in hr2lr.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   make_land_retr_mask.pro
   ;
   ;  *   make_rdqi_fill_masks.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The MISR RCCM files do not include a quality indicator
   ;      like RDQI, nor fill values to flag edge or obscured pixels,
   ;      however, the cloud mask information is available separately for
   ;      each spectral band. These are retrieved separately from the
   ;      appropriate L1B2 file (of the same MODE, PATH, ORBIT and BLOCK)
   ;      and inserted in the revised cloud mask generated by this
   ;      function.
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES:
   ;
   ;  *   Mike Bull, Jason Matthews, Duncan McDonald, Alexander Menzies,
   ;      Catherine Moroney, Kevin Mueller, Susan Paradise and Mike
   ;      Smyth (2011) ’Data Products Specifications’, JPL D-13963,
   ;      Revision S, page 85, available from
   ;      https://eosweb.larc.nasa.gov/project/misr/DPS_v50_RevS.pdf.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–08: Version 0.9 — Initial release by Linda Hunt.
   ;
   ;  *   2018–08–20: Version 1.0 — Initial public release.
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
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, ' + $
            'misr_orbit, misr_block, rccm_cloud, rev_rccm_cloud.'
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

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   cameras = misr_specs.CameraNames
   numcams = misr_specs.NCameras
   bands = misr_specs.BandNames
   numbands = misr_specs.NBands

   ;  Set the codes identifying the pixels obscured by topography, or not
   ;  observed by the camera:
   obs_fill = 16377U
   edg_fill = 16378U

   ;  Initialize the counters for the various categories of situations:
   very_clear = 0
   most_clear = 0
   lowc_clear = 0
   ambiguous = 0
   lowc_cloud = 0
   most_cloud = 0
   very_cloud = 0
   unretrievd = 0
   unclassifd = 0

   ;  Create the revised cloud mask array as a copy of the original RCCM cloud
   ;  mask (this sets all original values from 0 to 4):
   rev_rccm_cloud = rccm_cloud

   ;  Determine the retrievability of the standard land product as an ancillary
   ;  help to determine the likely status (clear or cloudy) of any missing
   ;  pixel:
   rc = make_land_retr_mask(misr_path, misr_orbit, misr_block, $
      land_retr_mask, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Initialize the counters for the number of missing pixels, the number of
   ;  missing pixels processed
   num_missing = 0
   num_pixels = 0
   num_mp_pixels = 0

   ;  Create the structure to contain the statistics about missing pixels:
   miss_pix_struct = REPLICATE({bpi, $
      misr_mode:'', $
      misr_path:0, $
      misr_orbit:0L, $
      misr_block:0, $
      camera:'', $
      pix_sample:0, $
      pix_line:0, $
      mean3:0.0, $
      stdev3:0.0, $
      rct3:0.0, $
      mean5:0.0, $
      stdev5:0.0, $
      rct5:0.0, $
      land_retr:0, $
      fixed_val:0B}, 1)

   ;  Loop over the 9 MISR RCCM files (1 per camera):
   FOR c = 0, numcams - 1 DO BEGIN

   ;  Extract the standard cloud mask for the current camera:
      cam_cloud_mask = REFORM(rccm_cloud[c, *, *])

   ;  Retrieve the fill and RDQI values appropriate for the pixels in the red
   ;  spectral band from the standard L1B2 file for the same camera and
   ;  spectral band:
      rc = make_rdqi_fill_masks(misr_mode, misr_path, misr_orbit, $
         misr_block, cameras[c], bands[2], fill_mask_red, $
         rdqi_mask_red, DEBUG = debug, EXCPT_COND=excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Downscale this red mask to match the spatial resolution of the RCCM
   ;  product (the red band is always available at the full spatial resolution
   ;  in L1B2 files):
      lr_fill_mask_red = hr2lr(fill_mask_red, DEBUG = debug, $
         EXCPT_COND=excpt_cond)
      IF (debug AND (excpt_cond NE '')) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      fill_mask_red = lr_fill_mask_red

   ;  Retrieve the fill and RDQI values appropriate for the pixels in the NIR
   ;  spectral band from the standard L1B2 file for the same camera and
   ;  spectral band:
      rc = make_rdqi_fill_masks(misr_mode, misr_path, misr_orbit, $
         misr_block, cameras[c], bands[3], fill_mask_nir, $
         rdqi_mask_nir, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 230
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Downscale this NIR mask to match the spatial resolution of the RCCM
   ;  product if it originates from the AN camera or from a Local Mode L1B2
   ;  file:
      IF ((cameras[c] EQ 'AN') OR (misr_mode EQ 'LM')) THEN BEGIN
         lr_fill_mask_nir = hr2lr(fill_mask_nir, DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         IF (debug AND (excpt_cond NE '')) THEN BEGIN
            error_code = 240
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
         fill_mask_nir = lr_fill_mask_nir
      ENDIF

   ;  Fill in the edge pixels in the cloud mask with the value 254
   ;  (different from 0, which means not retrieved), using the edge locations
   ;  obtained from the L1B2 Red and NIR files:
      edge_red_loc = WHERE(fill_mask_red EQ edg_fill, red_edg_cnt)
      edge_nir_loc = WHERE(fill_mask_nir EQ edg_fill, nir_edg_cnt)
      IF (red_edg_cnt GT 0) THEN BEGIN
         cam_cloud_mask[edge_red_loc] = 254
         rev_rccm_cloud[c, edge_red_loc] = 254
     ENDIF
     IF (nir_edg_cnt GT 0) THEN BEGIN
         cam_cloud_mask[edge_nir_loc] = 254
         rev_rccm_cloud[c, edge_nir_loc] = 254
     ENDIF

   ;  Fill in the obscured pixels in the cloud mask with the value 253
   ;  (different from 0, which means not retrieved), using the edge locations
   ;  obtained from the L1B2 Red and NIR files:
      obsc_red_loc = WHERE(fill_mask_red EQ obs_fill, red_obs_cnt)
      obsc_nir_loc = WHERE(fill_mask_nir EQ obs_fill, nir_obs_cnt)
      IF (red_obs_cnt GT 0) THEN BEGIN
         cam_cloud_mask[obsc_red_loc] = 253
         rev_rccm_cloud[c,obsc_red_loc] = 253
      ENDIF
      IF (nir_edg_cnt GT 0) THEN BEGIN
         cam_cloud_mask[obsc_nir_loc] = 253
         rev_rccm_cloud[c, obsc_nir_loc] = 253
      ENDIF

   ;  Locate and count the missing (non-retrieved) pixels in the current
   ;  camera cloud mask:
      missing_loc = WHERE(cam_cloud_mask EQ 0, miss_cnt)
      num_missing = num_missing + miss_cnt

   ;  Get the dimensions of the current camera cloud mask:
      sz = SIZE(cam_cloud_mask, /DIMENSIONS)

   ;  Loop over the missing pixels in the current camera cloud mask:
      FOR p = 0, miss_cnt - 1 DO BEGIN

   ;  Retrieve the line and sample positions of the missing pixel:
         loc2d = ARRAY_INDICES(cam_cloud_mask, missing_loc[p])
         pix_sample = loc2d[0]
         pix_line = loc2d[1]

   ;  Identify and extract the 3 by 3 pixel area around the missing pixel, and
   ;  check that it does not spill over the sides of the current camera cloud
   ;  mask:
         left3 = pix_sample - 1
         IF (left3 LT 0) THEN left3 = 0
         right3 = pix_sample + 1
         IF (right3 GT sz[0] - 1) THEN right3 = sz[0] - 1

         top3 = pix_line - 1
         IF (top3 LT 0) THEN top3 = 0
         bottom3 = pix_line + 1
         IF (bottom3 GT sz[1] - 1) THEN bottom3 = sz[1] - 1

         pixcut3 = cam_cloud_mask[left3:right3, top3:bottom3]

   ;  Identify and extract the 5 by 5 pixel area around the missing pixel, and
   ;  check that it does not spill over the sides of the current camera cloud
   ;  mask:
         left5 = pix_sample - 2
         IF (left5 LT 0) THEN left5 = 0
         right5 = pix_sample + 2
         IF (right5 GT sz[0] - 1) THEN right5 = sz[0] - 1

         top5 = pix_line - 2
         IF (top5 LT 0) THEN top5 = 0
         bottom5 = pix_line + 2
         IF (bottom5 GT sz[1] - 1) THEN bottom5 = sz[1] - 1

         pixcut5 = cam_cloud_mask[left5:right5, top5:bottom5]

   ;  Compute the cloud coverage statistics for these surrounding areas, to
   ;  estimate whether the missing pixel might be clear or cloudy:
         notret = WHERE((pixcut3 EQ 0) OR (pixcut3 GT 250), nrct, $
            COMPLEMENT = ret3, NCOMPLEMENT = rct3)
         mean3 = MEAN(pixcut3[ret3])
         stdev3 = STDDEV(pixcut3[ret3])

         notret = WHERE((pixcut5 EQ 0) OR (pixcut5 GT 250), nrct, $
            COMPLEMENT = ret5, NCOMPLEMENT = rct5)
         mean5 = MEAN(pixcut5[ret5])
         stdev5 = STDDEV(pixcut5[ret5])

   ;  Locate the missing pixel inside the land retrievability mask:
         pix_land_retr = land_retr_mask[c, *, pix_sample, pix_line]

   ;  Accumulate the land retrievability index in the 4 spectral bands:
         land_retr = TOTAL(land_retr_mask[c, *, pix_sample, pix_line])

   ;  Assign the probability that the missing pixel is clear or cloudy.
   ;  If all neighbors are clear, the missing pixel is deemed clear:
         CASE 1 OF
            (mean5 EQ 4.0): BEGIN
               very_clear++
               fixed_val = 6B
            END

   ;  If most of the neighbors are clear, the missing pixel is deemed clear:
            (mean5 GE 3.5 AND mean5 LT 4.0): BEGIN
               most_clear++
               fixed_val  = 6B
            END

   ;  If some of the pixels are clear with low confidence, consult the land
   ;  retrievability masks in the four spectral bands for the current camera,
   ;  to see whether the pixel is deemed unretrievable as far as the
   ;  atmospheric correction is concerned:
            (mean5 GE 3.0 AND mean5 LT 3.5): BEGIN
               lowc_clear++
               IF (stdev5 LT 1.0 AND rct5 GE 13) THEN BEGIN
                  fixed_val = 6B
               ENDIF ELSE BEGIN
                  IF (land_retr GE 3) THEN fixed_val = 6B ELSE fixed_val = 5B
               ENDELSE
            END

   ;  If the situation is ambiguous, rely in the land retrievability mask:
            (mean5 GT 2.0 AND mean5 LT 3.0): BEGIN
               ambiguous++
               IF (land_retr GE 3) THEN fixed_val = 6B ELSE fixed_val = 5B
            END

   ;  If some of the pixels are cloudy with low confidence, consult the land
   ;  retrievability mask:
            (mean5 GT 1.5 AND mean5 LE 2.0): BEGIN
               lowc_cloud++
               IF (stdev5 LT 1.0 AND rct5 GE 13) THEN BEGIN
                  fixed_val = 5B
               ENDIF ELSE BEGIN
                  IF (land_retr GE 3) THEN fixed_val = 6B ELSE fixed_val = 5B
               ENDELSE
            END

   ;  If most of the neighbors are cloudy, the missing pixel is deemed cloudy:
            (mean5 GT 1.0 and mean5 LE 1.5): BEGIN
               most_cloud++
               fixed_val = 5B
            END

   ;  If all neighbors are cloudy, the missing pixel is deemed cloudy:
            (mean5 EQ 1.0): BEGIN
               very_cloud ++
               fixed_val = 5B
               IF land_retr GE 3 THEN final_val = 6B
            END

   ;  If the cloud coverage statistics is less than 1.0 or very large, the
   ;  values are unretrievable:
            (mean5 LT 1.0 OR mean5 GT 4.0): BEGIN
               unretrievd++
               fixed_val = 0B
               IF land_retr GE 3 THEN fixed_val = 6B
            END

   ;  In all other cases,
            ELSE : BEGIN
               PRINT, mean5, sample, line
               unclassifd++
            END
         ENDCASE

   ;  Update the number of missing pixels processed:
         num_pixels++

   ;  When processing the very first missing pixel, create the structure to
   ;  contain all details about the processing done earlier:
         IF ((c EQ 0) AND (p EQ 0)) THEN BEGIN
            num_mp_pixels++
            miss_pix_struct = [{bpi, misr_mode, misr_path, misr_orbit, $
               misr_block, cameras[c], pix_sample, pix_line, mean3, stdev3, $
               rct3, mean5, stdev5, rct5, land_retr, fixed_val}]
         ENDIF ELSE BEGIN
            num_mp_pixels++
            miss_pix_struct = [miss_pix_struct, {bpi, misr_mode, misr_path, $
               misr_orbit, misr_block, cameras[c], pix_sample, pix_line, $
               mean3, stdev3, rct3, mean5, stdev5, rct5, land_retr, fixed_val}]
         ENDELSE

   ;  Replace the missing value by the probable estimate computed in the CASE
   ;  statement above:
         rev_rccm_cloud[c, pix_sample, pix_line] = fixed_val

      ENDFOR
   ENDFOR

   RETURN, return_code

END
