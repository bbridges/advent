#include <iostream>

uint64_t get_checksum(std::vector<uint8_t> &disk)
{
  uint64_t disk_length = 0, data_length = 0;

  for (size_t i = 0; i < disk.size(); i++)
  {
    disk_length += disk[i];

    if (i % 2 == 0)
      data_length += disk[i];
  }

  uint64_t checksum = 0;
  size_t p = 0, left = 0, right = disk.size() % 2 == 0 ? disk.size() : disk.size() - 1;

  uint8_t right_remaining = disk[right];

  while (true)
  {
    for (uint8_t i = 0; i < disk[left]; i++, p++)
    {
      checksum += p * (left / 2);

      if (p == data_length - 1)
        return checksum;
    }

    left++;

    for (uint8_t i = 0; i < disk[left]; i++, p++)
    {
      while (right_remaining == 0)
      {
        right -= 2;
        right_remaining = disk[right];
      }

      checksum += p * (right / 2);

      if (p == data_length - 1)
        return checksum;

      right_remaining--;
    }

    left++;
  }
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
