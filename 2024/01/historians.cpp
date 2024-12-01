#include <algorithm>
#include <iostream>

int main()
{
  std::vector<int32_t> left, right;

  int32_t number;

  while (std::cin >> number)
  {
    left.push_back(number);

    std::cin >> number;
    right.push_back(number);
  }

  std::sort(left.begin(), left.end());
  std::sort(right.begin(), right.end());

  int32_t distance = 0;

  for (size_t i = 0; i < left.size(); i++) {
    distance += abs(left[i] - right[i]);
  }

  std::cout << distance << std::endl;

  return 0;
}
