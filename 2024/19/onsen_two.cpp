#include <iostream>
#include <map>

struct Node
{
  bool is_end;
  std::unique_ptr<Node> children[26];
};

uint64_t combinations(Node &root, std::string &line)
{
  std::map<Node *, uint64_t> curr_matches = {{&root, 1}}, prev_matches;

  auto incr = [](std::map<Node *, uint64_t> &matches, Node *match, uint64_t count)
  {
    if (matches.contains(match))
      matches[match] += count;
    else
      matches[match] = count;
  };

  for (size_t i = 0; i < line.size(); i++)
  {
    std::swap(curr_matches, prev_matches);
    curr_matches.clear();

    for (auto &[node, count] : prev_matches)
    {
      Node *child = node->children[line[i] - 'a'].get();

      if (child == nullptr)
        continue;

      if (child->is_end)
        incr(curr_matches, &root, count);

      incr(curr_matches, child, count);
    }

    if (curr_matches.empty())
      return 0;
  }

  uint64_t combinations = 0;

  for (auto &[node, count] : curr_matches)
    if (node->is_end)
      combinations += count;

  return combinations;
}

int main()
{
  std::string line;
  std::getline(std::cin, line);

  Node root = {.is_end = false, .children = {}};
  Node *curr = &root;

  for (size_t i = 0; i < line.size(); i++)
  {
    if (line[i] == ' ')
      continue;

    if (line[i] == ',')
    {
      curr->is_end = true;
      curr = &root;
      continue;
    }

    Node *next = curr->children[line[i] - 'a'].get();

    if (next == nullptr)
    {
      std::unique_ptr<Node> node(new Node{.is_end = false});
      next = node.get();

      curr->children[line[i] - 'a'] = std::move(node);
    }

    curr = next;
  }

  curr->is_end = true;

  std::getline(std::cin, line);
  uint64_t count = 0;

  while (std::getline(std::cin, line))
    count += combinations(root, line);

  std::cout << count << std::endl;
}
