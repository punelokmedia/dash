import { STATUS_MAP } from "../../constants/type";

interface Props {
  value: keyof typeof STATUS_MAP;
}

export default function Badge({ value }: Props) {
  const s = STATUS_MAP[value];

  return (
    <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold ${s.cls}`}>
      {s.label}
    </span>
  );
}