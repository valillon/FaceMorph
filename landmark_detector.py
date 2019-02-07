# import the necessary packages
from imutils import face_utils
import numpy as np
import argparse
import imutils
import dlib
import cv2
from skimage import io
from skimage.transform import resize
import os

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
# ap.add_argument("-p", "--shape-predictor", required=True, help="path to facial landmark predictor")
shape_predictor = 'shape_predictor_68_face_landmarks.dat'
ap.add_argument("-i", "--image", required=True, help="path to input image")
args = vars(ap.parse_args())

filename = args["image"]
out_dir, basename = os.path.split(filename)
name, extension = os.path.splitext(basename)
print('Searching facial landmarks for image ' + filename)
# initialize dlib's face detector (HOG-based) and then create
# the facial landmark predictor
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(shape_predictor)

# load the input image, resize it, and convert it to grayscale
image = cv2.imread(filename)
# image = imutils.resize(image, width=250)
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# detect faces in the grayscale image
print('Detecting faces...')
rects = detector(gray, 1)

# loop over the face detections
for (i, rect) in enumerate(rects):

    print('Recovering face parts for person #' + str(i))
    # determine the facial landmarks for the face region, then
    # convert the facial landmark (x, y)-coordinates to a NumPy
    # array
    shape = predictor(gray, rect)
    shape = face_utils.shape_to_np(shape)

    # convert dlib's rectangle to a OpenCV-style bounding box
    # [i.e., (x, y, w, h)], then draw the face bounding box
    (x, y, w, h) = face_utils.rect_to_bb(rect)
    cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

    # show the face number
    cv2.putText(image, "Face #{}".format(i + 1), (x - 10, y - 10),
    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    # loop over the (x, y)-coordinates for the facial landmarks
    # and draw them on the image
    for (x, y) in shape:
        cv2.circle(image, (x, y), 1, (0, 0, 255), -1)

    # loop over the (x, y)-coordinates for the facial landmarks
    # and write them on a file
    landmarks_file = out_dir + '/' + name + '.txt'      # overwrites landmarks for images with multiple faces
    f = open(landmarks_file, 'wb')
    f.truncate(0)                                       # cleaning
    for (x, y) in shape:
        f.write(str(x) + ' ' + str(y) + '\n')
    
    f.close()
    print('Landmarks exported to ' + landmarks_file)    


# Show the output image with the face detections + facial landmarks
# cv2.imshow("Facial landmarks", image)
# print("Select the opened window and press a key to finish")
# cv2.waitKey(0)
cv2.imwrite(out_dir + '/' + name + '_landmarks.jpg', image)

if len(rects) == 0 : print("Warning! no faces have been detected")
else : print('Done!')

