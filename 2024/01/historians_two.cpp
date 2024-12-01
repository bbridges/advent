#include <iostream>
#include <map>

int main()
{
  std::map<int32_t, int32_t> left, right;

  int32_t number;

  while (std::cin >> number)
  {
    if (left.contains(number))
      left[number] += 1;
    else
      left[number] = 1;

    std::cin >> number;

    if (right.contains(number))
      right[number] += 1;
    else
      right[number] = 1;
  }

  int32_t similarity = 0;

  for (auto &[l, freq] : left)
  {
    similarity += freq * l * right[l];
  }

  std::cout << similarity << std::endl;

  return 0;
}
