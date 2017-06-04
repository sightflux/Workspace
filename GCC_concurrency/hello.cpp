#include <iostream>
#include <thread>
#include <chrono>

using namespace std::chrono_literals;

struct Data {
  int x;
};

void update_data(Data& data)
{
  data.x = 1;
}

void problem()
{
  Data data;
  std::thread t(update_data, std::ref(data));
  // std::thread t(update_data, std::ref(data));
  t.join();

  std::cout << data.x << std::endl;
}

int main()
{
  problem();
}
