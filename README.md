# Face Morphing

This code generates a morphing effect between two faces.		
1. Facial landmarks recognition is performed in both faces (dlib).	
2. Finds Delaunay triangles.	
3. Performs affine transformation between delaunay triangles from both faces.		
4. Applies alpha blending on the correspding triangles with a given transparency.	

Steps 3 and 4 are iterated for different values of alpha to generate a bunch of morphing frames.	
After that the frames are converted into a video file.	

## Attribution

This code is a modification of the code originally posted in [blog post](https://www.learnopencv.com/face-morph-using-opencv-cpp-python/) for more details about this code [Face Morph Using OpenCV — C++ / Python](https://www.learnopencv.com/face-morph-using-opencv-cpp-python/).

Note that unlike the original code, only the corners and half way points are added to the facial keypoints.
Additional neck and ears points manually added in the original code, have been omitted to make it completely automatic.

## Dependencies for macOS

Run the script or install each included library in:	 	
```bash
$ ./install_morphing_dependencies.sh`
```

## How to run?

The following script runs the entire pipeline.

```bash
$./run_morphing.sh <image1> <image2> <framrate> <duration>
```
The 1st and 2nd arguments are the departure and destination images respectively.		
The 3rd argument stands for the framerate.	
The 4th argument stands for the morphing duration in seconds.	

## Example

```bash
$./run_morphing.sh ./example1/hillary_clinton.jpg ./example1/donald_trump.jpg 30 2
```

## Bonus

### How to create caricatures

Make landmarks from the first face stay for every morphing iteration.	
That will transfer the facial expression from one face to the other.	
There are cleaner ways to do it, but a simple one is to comment the line below where landmarks are refreshed.

```python
for (f, a) in enumerate(np.linspace(0,100,n_frames)) :
	# some code here
    # points = []	    # Comment this line to get a cartoon effect          
```

Order 2 frames if you just like to have the cartoon frame:	

```bash
$./run_morphing.sh <image1> <image2> 2 1
```

### How to create a loop-back effect

Just make `alpha` range double and then decrease it when exceeds 1.

```python
for (f, a) in enumerate(np.linspace(0,100,n_frames)) :

    alpha = float(a) / 100
    
    alpha = 2 * alpha
    if alpha > 1 :  alpha = 2 - alpha    
```

### How to save the Delaunay triangles.

Run the script with the desired image as input.	
Delaunay and Voronoi segmentations are saved next to the input image.	
Unlike the morphing effect, no corners are used here, only facial landmarks.	

```bash
$ ./python delaunay.py -i <image>
```