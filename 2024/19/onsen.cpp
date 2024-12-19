#include <iostream>
#include <set>

struct Node
{
  bool is_end;
  std::unique_ptr<Node> children[26];
};

bool is_possible(Node &root, std::string &line)
{
  std::set<Node *> curr_matches = {&root}, prev_matches;

  for (size_t i = 0; i < line.size(); i++)
  {
    std::swap(curr_matches, prev_matches);
    curr_matches.clear();

    for (Node *node : prev_matches)
    {
      Node *child = node->children[line[i] - 'a'].get();

      if (child == nullptr)
        continue;

      if (child->is_end)
        curr_matches.insert(&root);

      curr_matches.insert(child);
    }

    if (curr_matches.empty())
      return false;
  }

  return true;
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

  int count = 0;

  while (std::getline(std::cin, line))
    if (is_possible(root, line))
      count++;

  std::cout << count << std::endl;
}
