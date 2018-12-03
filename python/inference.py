import tensorflow as tf
from PIL import Image
import tensorflow as tf
import numpy as np
import cv2
import matplotlib.pyplot as plt

class OD:
    def __init__(self):
        config = tf.ConfigProto(allow_soft_placement=True)
        config.gpu_options.allow_growth = True
        config.gpu_options.per_process_gpu_memory_fraction = 1

        detection_graph = tf.Graph()
        with detection_graph.device('/gpu:' + str(0)):
            with detection_graph.as_default():
                od_graph_def = tf.GraphDef()
                with tf.gfile.GFile('frozen_inference_graph.pb', 'rb') as fid:
                    serialized_graph = fid.read()
                    od_graph_def.ParseFromString(serialized_graph)
                    tf.import_graph_def(od_graph_def, name='')

                self.sess = tf.Session(graph=detection_graph, config=config)
                # Fetching tensors from the graph
                self.image_tensor = detection_graph.get_tensor_by_name('image_tensor:0')
                self.detection_boxes = detection_graph.get_tensor_by_name('detection_boxes:0')
                self.detection_scores = detection_graph.get_tensor_by_name('detection_scores:0')
                self.detection_classes = detection_graph.get_tensor_by_name('detection_classes:0')
                self.num_detections = detection_graph.get_tensor_by_name('num_detections:0')

    def infer(self, image):
        image_np_expanded = np.reshape(image, (1, 540, 960, 3))
        (boxes, scores, classes, num) = self.sess.run(
            [self.detection_boxes, self.detection_scores, self.detection_classes, self.num_detections],
            feed_dict={self.image_tensor: image_np_expanded})
        scores = scores[0]
        indexs = np.where(scores >= 0.90)
        for index in indexs[0]:
            x1 = int(540 * boxes[0][index][0])
            y1 = int(960 * boxes[0][index][1])
            x2 = int(540 * boxes[0][index][2])
            y2 = int(960 * boxes[0][index][3])
            cv2.rectangle(image, (y1, x1), (y2, x2), (0, 255, 0), 2)
        return image, len(indexs[0])

