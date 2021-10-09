import Config
from openravepy import *
from src.DataStructures.ArgExecutor import ArgExecutor

class GripperCloseTrajectory(ArgExecutor):

    def __init__(self,argument_name):
        super(GripperCloseTrajectory,self).__init__(argument_name)

    def __deepcopy__(self, memodict={}):
        return GripperCloseTrajectory(self.argumnet_name)

    def apply(self,simulator,value,other_generated_values):
        robot = simulator.env.GetRobot(Config.ROBOT_NAME)
        taskmanip = interfaces.TaskManipulation(robot)
        if value == "close":
            robot.Grab(simulator.env.GetKinBody(other_generated_values["obj"]))

    def execute(self,simulator,value,other_generated_values):
        robot = simulator.env.GetRobot(Config.ROBOT_NAME)
        taskmanip = interfaces.TaskManipulation(robot)
        state = value
        if state == "close":
            with robot:
                if robot.GetName() == 'yumi':
                    taskmanip.CloseFingers(movingdir=[-1])
                else:
                    taskmanip.CloseFingers()
                robot.Grab(simulator.env.GetKinBody(other_generated_values["obj"]))
            robot.WaitForController(0)
