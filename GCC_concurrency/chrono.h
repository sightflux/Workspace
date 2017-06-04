#include <iostream>
#include <chrono>

class Download
{
public:
  Download(std::string _url):url(_url) {};

  void operator()()
  {
    std::cout << "Download " << url << std::endl;
  }
private:
  std::string url;
};
