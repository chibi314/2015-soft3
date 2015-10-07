#!/usr/bin/env python

import rospy
import roslib, os, imp
client = imp.load_source('add_two_ints', os.path.join(roslib.packages.get_pkg_dir('beginner_tutorials'),'scripts/add_two_ints_client.py'))

import sys
import unittest

## A sample python unit test
class TestClient(unittest.TestCase):
    def test_check(self):
        self.assertEquals(client.add_two_ints_client(1,2), 3, "1+2=3")

if __name__ == '__main__':
    import rostest
    rostest.rosrun('beginner_tutorials', 'test_client', TestClient)



