#include <iostream>

class TWork
{
public:
  TWork(int _taskIndex, int _threadIndex)
  {
    taskIndex = _taskIndex;
    threadIndex = _threadIndex;
  }
  ~TWork()
  {

  }

  void operator() ()
  {
    while(taskIndex < 100)
    {
      taskIndex++;
      std::cout << "Thread" << threadIndex << " = " << taskIndex << "!" << std::endl;
    }
  }

private:
  int taskIndex;
  int threadIndex;
};
