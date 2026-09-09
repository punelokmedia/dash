interface Props {
  initials: string;
  size?: string;
  text?: string;
}

export default function Avatar({
  initials,
  size = "w-9 h-9",
  text = "text-sm",
}: Props) {
  return (
    <div className={`${size} rounded-full bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center text-white font-bold ${text}`}>
      {initials}
    </div>
  );
}