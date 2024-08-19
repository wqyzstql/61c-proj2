import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    def test_one(self):
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        arr0 = t.array([1, 2, 3, 4, 5])
        arr1 = t.array([1, 3, 3, 5, 6])
        arr2 = t.array([0, 0, 0, 0, 0])
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)
        t.input_scalar("a2", 5)
        t.input_array("a3", arr2)
        t.call("abs_loss")
        t.check_scalar("a0", 3)
        t.execute()
    def test_len_error(self):
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        arr0 = t.array([])
        arr1 = t.array([])
        arr2 = t.array([])
        t.input_array("a0", arr0)           
        t.input_array("a1", arr1)
        t.input_scalar("a2", 0)
        t.input_array("a3", arr2)
        t.call("abs_loss")
        t.execute(code=36)     

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def test_simple(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        arr0 = t.array([1, 2, 3, 4, 5])
        arr1 = t.array([1, 3, 3, 5, 7])
        arr2 = t.array([0, 0, 0, 0, 0])
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)
        t.input_scalar("a2", 5)
        t.input_array("a3", arr2)
        t.call("squared_loss")
        t.check_scalar("a0", 6)
        t.execute()
    def test_len_error(self):
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        arr0 = t.array([])
        arr1 = t.array([])
        arr2 = t.array([])
        t.input_array("a0", arr0)           
        t.input_array("a1", arr1)
        t.input_scalar("a2", 0)
        t.input_array("a3", arr2)
        t.call("squared_loss")
        t.execute(code=36)    

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def test_simple(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        arr0 = t.array([1, 2, 3, 4, 5])
        arr1 = t.array([1, 3, 3, 5, 7])
        arr2 = t.array([0, 0, 0, 0, 0])
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)
        t.input_scalar("a2", 5)
        t.input_array("a3", arr2)
        t.call("zero_one_loss")
        t.check_array(arr2, [1, 0, 1, 0, 0])
        t.execute()
    def test_len_error(self):
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        arr0 = t.array([])
        arr1 = t.array([])
        arr2 = t.array([])
        t.input_array("a0", arr0)           
        t.input_array("a1", arr1)
        t.input_scalar("a2", 0)
        t.input_array("a3", arr2)
        t.call("zero_one_loss")
        t.execute(code=36)   

    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    answer_array=[0, 0, 0, 0]
    def test_simple(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        t.input_scalar("a0",4)
        t.call("initialize_zero")
        t.check_array_pointer("a0",self.answer_array)
        t.execute()
    def test_len_error(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        t.input_scalar("a0",0)
        t.call("initialize_zero")           
        t.execute(code=36)
    def test_len_error(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        t.input_scalar("a0",4)
        t.call("initialize_zero")
        t.execute(fail="malloc", code=26)

    # Add other test cases if neccesary

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
