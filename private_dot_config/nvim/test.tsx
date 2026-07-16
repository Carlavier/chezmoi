import React, { useState } from "react";

interface User {
  id: number;
  name: string;
  role: "admin" | "user";
}

interface Props {
  title: string;
  initialUsers: User[];
}

export const UserList: React.FC<Props> = ({ title, initialUsers }) => {
  const [users, setUsers] = useState<User[]>(initialUsers);
  const [input, setInput] = useState<string>("");

  const addUser = (): void => {
    if (!input.trim()) return;
    const newUser: User = {
      id: Date.now(),
      name: input,
      role: "user",
    };
    setUsers([...users, newUser]);
    setInput("");
  };

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>): void => {
    if (e.key === "Enter") addUser();
  };

  return (
    <div className="p-4 border rounded-lg max-w-md">
      <h2 className="text-xl font-bold mb-4">{title}</h2>
      <div className="flex gap-2 mb-4">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={handleKeyPress}
          placeholder="Enter name"
          className="border p-2 flex-grow"
        />
        <button
          onClick={addUser}
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Add
        </button>
      </div>
      <ul className="space-y-1">
        {users.map((user) => (
          <li
            key={user.id}
            className="p-2 bg-gray-100 rounded flex justify-between"
          >
            <span>{user.name}</span>
            <span className="text-xs text-gray-500 capitalize">
              {user.role}
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
};
