FUNCTION lr2hr, inarray, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function upsizes a low spatial resolution (512 × 128)
   ;  data field from a MISR L1B2 Georectified Radiance Product (GRP)
   ;  Terrain-Projected Top of Atmosphere (ToA) Global Mode (GM) Radiance
   ;  file to a full (native) spatial resolution (2048 × 512), i.e.,
   ;  upgrades the dimensions of the input argument to match those of a
   ;  MISR L1B2 array in the red spectral band.
   ;
   ;  ALGORITHM: This function duplicates 16 times the value of each pixel
   ;  in the low-resolution data set to generate a pseudo high-resolution
   ;  array.
   ;
   ;  SYNTAX:
   ;  outarray = lr2hr(inarray, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   inarray {Numeric} [I]: An array of 512 × 128 elements,
   ;      presumably retrieved from one of the low spatial resolution
   ;      grids of an L1B2 GRP ToA GM radiance file.
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
   ;  RETURNED VALUE TYPE: Numeric array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns a numeric array of the same type as inarray and
   ;      dimensioned 2048 × 512 elements, where each element of inarray
   ;      is duplicated 16 (4 × 4) times in outarray. The output keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns an INTEGER array dimensioned 2048 × 512 elements, where
   ;      each element is set to -1, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter inarray is not of a numeric
   ;      type.
   ;
   ;  *   Error 120: Positional parameter inarray is not properly dimensi
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since this function only duplicates the original values
   ;      (16 times), it does not change the information content of the
   ;      original file. Contrast this with the function hr2lr.pro.
   ;
   ;  *   NOTE 2: The generation of MISR-HR L1B3 product does NOT rely on
   ;      this function, which is used exclusively for mapping all MISR-HR
   ;      L1B2 fields at the same apparent spatial resolution in all
   ;      cameras and spectral channels.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> inarray = FLTARR(512, 128)
   ;      IDL> outarray = lr2hr(inarray, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> HELP, outarray
   ;      OUTARRAY        FLOAT     = Array[2048, 512]
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2012–11–22: Version 0.5 — Initial release by Linda Hunt (as
   ;      upsize_array).
   ;
   ;  *   2017–07–17: Version 0.9 — Changed the function name to lr2hr,
   ;      removed arguments factor (fixed, in this context) and maxgood
   ;      (not used), added tests and in-line documentation.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–13: Version 1.1 — In-line documentation update.
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
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: inarray.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'inarray' is not of numeric type:
      IF (is_numeric(inarray) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument inarray is not numeric.'
         RETURN, return_code
      ENDIF
   ENDIF

   sz = SIZE(inarray, /STRUCTURE)
   xdim = sz.dimensions[0]
   ydim = sz.dimensions[1]

   ;  Return to the calling routine with an error message if the argument
   ;  'inarray' is not properly dimensioned:
      IF ((debug) AND ((xdim NE 512) OR (ydim NE 128))) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument inarray is not properly dimensioned: ' + $
            'must be [512 x 128].'
         RETURN, return_code
      ENDIF

   ;  Declare the output array:
   factor = 4
   outarray = MAKE_ARRAY(xdim * factor, ydim * factor, TYPE = sz.type)

   ;  Set the elements of the high spatial resolution (2048 x 512) output
   ;  array as duplicates of the low spatial resolution (512 x 128) input
   ;  array in successive 4 x 4 areas:

   FOR i = 0, xdim - 1 DO BEGIN
      FOR j = 0, ydim - 1 DO BEGIN
         outarray[i * factor:((i + 1) * factor) - 1, $
            j * factor:((j + 1) * factor) - 1] = inarray[i, j]
      ENDFOR
   ENDFOR

   RETURN, outarray

END
