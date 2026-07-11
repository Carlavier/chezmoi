import React, { useState } from "react";

interface Props {
	name: string;
	age: number;
}

function Greeting({ name, age }: Props) {
	const [count, setCount] = useState(0);
	return (
		<div>
			<h1>Hello, {name}!</h1>
			<p>You are {age} years old.</p>
			<p>Count: {count}</p>
			<button onClick={() => setCount(count + 1)}>Increment</button>
		</div>
	);
}

export default Greeting;
