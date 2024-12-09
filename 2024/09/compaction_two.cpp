#include <iostream>

struct Gap
{
  size_t start;
  size_t end;
};

uint64_t get_checksum(std::vector<uint8_t> &disk)
{
  uint64_t disk_length = 0;
  std::vector<Gap> gaps;

  for (size_t i = 0; i < disk.size(); i++)
  {
    if (i % 2 == 1 && disk[i] != 0)
      gaps.push_back({.start = disk_length, .end = disk_length + disk[i]});

    disk_length += disk[i];
  }

  uint64_t checksum = 0;
  size_t p = disk_length - 1, i = disk.size() % 2 == 0 ? disk.size() : disk.size() - 1;

  while (i > 0)
  {
    Gap *g = nullptr;

    for (size_t k = 0; g == nullptr && k < gaps.size() && gaps[k].end < p; k++)
      if (gaps[k].end - gaps[k].start >= disk[i])
        g = &gaps[k];

    if (g != nullptr)
      for (uint8_t j = 0; j < disk[i]; j++, p--, g->start++)
        checksum += g->start * (i / 2);
    else
      for (uint8_t j = 0; j < disk[i]; j++, p--)
        checksum += p * (i / 2);

    p -= disk[i - 1];
    i -= 2;
  }

  return checksum;
}

int main()
{
  std::string input;
  std::cin >> input;

  std::vector<uint8_t> disk(input.size());

  for (size_t i = 0; i < input.size(); i++)
    disk[i] = input[i] - '0';

  std::cout << get_checksum(disk) << std::endl;
}
