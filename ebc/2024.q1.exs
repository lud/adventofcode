# Part 1

defmodule Part1 do
  def input do
    "BCBCCCACBCACBBACAAABBCCBAACBBCCACAAACACACCBCABBBCBBBCBCAABBCAACCCBBBBBBAACACCBBCABCCABCAABBBCBCBBCAAACBBCACAACBABCACACBABACABBBBAABBACACBCBBCCCCAAACACAACCACBBCACABAAACABBCCCBCCCABBABBABCBACCBBCACCAACBCBAAAACBABBAABCCABCBCABBBAABAACBACACAACBBCACACABABBBCCCAAABAAAAACACCABAABCCAAAAAACCABBBCACABCBAACCAABBBBCBACAACBBCCABABCBABABBBACCABBABBCBBBCABABCCCBABBABCBBAACCCBBABBAAAAAAAACBCACCCCABCBBCCCCAAACAAABBCCABBBACBBCBCCABACABCBBCBBAACCCCBCCCACAACAAACBCCAACBACCACCACACCCCBBBCCABCBBACCAABBCBCACACBCBCCCCBBAABBABBAABACCBCBABCCBACBBAACCBBACBABACBBCCCABABBBBBAACBBCACCCAAACBCBBBBACBABBABBAAAACBACBAABACCACABBCBAABABBACACAACBBBCBBAAAAABCACCABBACACABBBBACCCBBCCABABBAACABBCBBBAABCCABBCAABBCAABBBBAAAACCBCCABCCAABBACCAACBAACBCCCBBBBCCCACCCAAABCAAAAACCACBAAACAACBCCBBACABCCACABCCBCBCABABCBBACCAAABBCBCBCCCBBCBCBBCACBBCBCAAABACABBAACBCCCACCCCABBAACCBCCCAAABAAAACBCBCCACCACCAABBBCBCBCABCBCCBBCBAACBCBACACCBACBBCCCABACACBAACACBBBABABCAACABCBBACAAAACCACACBCBABBCCBACBCCBCCCBCBCBCCBACACBCABACBCABACCACCBAAAACAACBCAABBC"
  end

  def solve do
    input()
    |> String.graphemes()
    |> Enum.frequencies()
    |> case do
      %{"B" => b, "C" => c} -> b + c * 3
    end
  end
end

defmodule Part2 do
  def input do
    "CACBCCBCxADBxCxBBxDAAxBxBCxADAxDCBBBBBADCDCCAAACBAADDCxCDDBCABxBDAAAACxxCACCDDCBBBBCABxBBxBAABDCAACDCBABxDxxBDBAxCDxCCAABAxBDACCDCACxxBxBBxACDBCBDADDDABAABxCBADDxDCDCCxDDDACAxACxABAAABDxDADCABBABDDBACxADAABBCBxACCBCDBDBCCCAADDDxDAADDxBDCCAABDBADBBCAxCBAABCCCCACAAADDDBDxDACAADDBCDxCADCCCBxCCCBADBxBBBBBxACBCDxAxDDDBCCBCCBDDADBDCDDxCDCDDCCACxDBCAAxDCACBDCABAACxBADDBxACBAAABBxBCCxCDDxCDCCDDBBDACAADCDCxCCBDAxDBABDxAACCACABxDCBBCCBADxACDxxxDBxDDDABCCCBCBAAxABADDADxDCBCADxBCBxDDAxACBDxDBCAxCAAxAxACBCxDDACBCxBCBxBDCADABCDxAADCACBBBBBBADCCACBAABxBDCBBDDxDBACDABADxACAxCCxAxBBDBDCABBxBAABDBCxxDBDDAABDCDCADxDDABABBCCBDCCACBCCCxCACBBDCxABAxCADBBDDBCCCACABCCBADDDDDDxCACCBCxDxCBxCDDCCACxDxBBAACBDABDxDABAxDABBDDABBBxBBBCAABCABACDDBCDABDBADDBABxACAxCAxDABDACCABBADBxCACABABAxxACCDADBDCBACDBAABACBAAxABBCCDxDBABDCBBxDDDAADxDBCBCAADBDADCDBBxxCBCxDACCDBCBCDCCABCBBDACADADADBCACBADxDBAACBABDCDDBCBBCDCBDDDDCBACADCAxCACDAACDACDDxBDBBBDBDCBDDCCCDCCxDACBAAxxDCCDBBBBBABBDCBABACCDADDxADDACCCBAABABxCDxDCxDBCxCDADCCAxAxBAxBBxBACDAADxABCBDBACCxBDACDDDCDCCBCDCxCxBCBDxADACCDCDxDAAxABCDDDDCACCABxDDDBBADCBABCDCCBBCBCBxxDBCBxAxBCCCBCAAABxCCDDBBDBBDCCACBABBDCAxAxACDCABCAxDCDABBDBDxxCxCDAAxACCCAABDABBBxDCACCCCDxACDBDBBAxBDxACAABDACCABCBxBBCACCADBBCCCxCBBCDBBBADxCBACBBCCCAxDxAxBDCADABxxAACCBCxDCBDDCxDBBDCCxAAACCBCxACAADCAADAADDCACxBxDDDBDCCxDBDBAADBBCxBCAxDCCBDCABACBDDCCBBCACxCCxBBCCABBxDAACDDAAACDACBBBAABDBACDxxCDABABADxDCCAADBxADADxDxBABDBAxCCBDBxACBABxACxAxABBADBACCBCBDxADBBACBAxBDCACBBDBDBDBDBBxADBCCBACDCACBxDBCCCAACDBDBDBAAACxDDBADAxDxDCCAxxDDCAABBxBBCCCAxAADxDBABBBBCDBBDBBDCBxBCBxDCxADDACBBCCBAADCBAxDCxxBBDxCBDDDADADADABDCDABxADBDDADCAAABADBBxADDDDDxBBDDCBBCDxCBxxCACCBCDACDDCDCxxDxDCACxCAADCCDAACBAADCxxBABDxCxBABDCADBDADACBAABACxCCBBBBBABDCBABDDACABDCBCDABCDDCBCCCxDDCABCAxCDCBACDCBCDDAAAADCCBDxBACxDDADDDAxCDDCDADAABxxBDCCDBCDxBDABCDDABCBCADACAAADxCBDAACABDADBBAABxBCCABCDxBCADBACDDAxCxxCDCxDADBADACDCAxDBAACxDDBCxBDBADCDDBACCACDDCBAACCCCCAxDCCAACCADBBCDDBCABBDACADAAACBCxCxxDCBDBDDDBDDBBBAACADxBDCACBCAx"
    # "AxBCDDCAxD"
  end

  def solve do
    input()
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      ["x", "x"] -> []
      ["x", c] -> c
      [c, "x"] -> c
      [c, c2] -> {c, c2}
    end)
    |> Enum.reduce(0, fn pair, acc -> score_of(pair) + acc end)
  end

  defp score_of(pair) do
    pair |> IO.inspect(label: "pair")

    score =
      case pair do
        {c1, c2} -> score_of(c1, 1) + score_of(c2, 1)
        [] -> 0
        c -> score_of(c, 0)
      end

    score |> IO.inspect(label: "score")
  end

  defp score_of("A", add), do: add
  defp score_of("B", add), do: 1 + add
  defp score_of("C", add), do: 3 + add
  defp score_of("D", add), do: 5 + add
end

defmodule Part3 do
  def input do
    "CCADxADBxCBDCDxAABDCDxACDAAACBxCxxBCDxAAAACxDCBxACDBCDACDxCCABxDADBxBDDBDBxABAAxCxBBxBDBAxBCDBBDADCDxCBCDADDCxxADCDDADBCAxAxCDADAAAxAAxxAxxBxCxBDxCCCBBAxABDADxACCDDBDACxDAxBDxDxDCDDBxCBDxCDDDCxxDxCxxCDxCADACABDDBBBBBADCBCBDDADDABBADADCDABDxAACxBDDBCCxBxDAxCDABxCxDDBDDDDDxBBBBxDCDCAxCADCBAAxABCACAxCBBAACADACDDDxxBBDCCxADxxDAACDBDDBCBDAxDCBBBBxDCCDADBDCBBDADxAADADxABCDBBBACAxCDCCCBBDxADADDCDCDAAABADDxxxCBCCBxAADAxDCxABAAADBCDxBBDADDCBADCABxxDBxACAAxxDACBxCxDACAADBDDDBCDxxBxDCCBCBCDDABDxBDAxCAxBCBBABABABBAxADDxACCBCCCDDCDCCAABABDADAxADBABACCxAACxCADCDxACCACCABADAAACxDADxBBCxAxCBDBADBDBBCCDDCDDBCCxACDBAADxCBxBDACxxDAxxxxxCDCACDADDAAxBCBDDDAxCCxACxCBBCDxCxBDBACAxBBCACDDxBxDBxCAAxCBBCxCCADAxBBCBAxxCCCBDCxCACDxADxCxBAxCxAACADDxCACBDxBADDxBxCxBxABAADABxCCBABDDABCAxBxCCxDCDBDBDCDCCDAAAxBDDDDxBxxCBDBxABDxxxBCxCBBDDBBCDCDBBBAAAACBBBBABDxAxAABBABDAAAAAxDDDBCAxxDCxBxCBAxDxxABAxADAxCBDDxAABAxxDCCxDDCxACAACBCBBxBxAAxDxADCDCABABBCDxBxBDCAxCCCABBCBxDDCACBxCAxCDBDCBxABDCxCDDxDABAADxADDBADxBCxADDBDxAxBAxxxACCAxDCAxCCACAAxCAADBDBCCAACxAAxDBBBDxxCBxDCxADxBCBDBBCCBBAxACCxAADBDAxBADxxxDBABxCxCABBxBAxDxxACADCBDBBBxACBDAxDCxBDBxxCxBADBABxxACCABDDADCDACBxDDDDBCxxDBABDCAxAACCCxADAxBACCxCDxCDDAxDDCDDACBCCDxBBxADABDAxxDAxBBCxxxDBDDABCDCCCADAxxCCBxCDADADDBxDxAxxADAABDACCCABBCxxCxxDCCxxBBAAxDDACCAxBDAABADCBABDxAxACBCDxACCAAACxxABxADBCxAADDBDDxxCCACBADxAAxDDxBxCCxDBCDDDxxDDBDCACBACCDxABxBCACBBAAxBBDxBCACBCxBxAACCABxAxAAxBAAxCBxxBxBxxxCxDAxADBxADAxAAxxAAADBBAxBxCBDBCBxBBACABAADxDCxxBDxDADCxAxDCxBBCBDxAACAAxxBCCxDCAxACBCCBCDBBDDAABADACCDDCABBBDABCAxDCxCBDxDBCAxBBxDxACBCBABACDxADDCDxDADCxDBAAxACBCDBxCBABDBADBDCCADCxDBCADBABBCBxxxABBBxBACBBxBDDBACDDCDDACCAxCADxBBCBCDADCxBDCDDBxDCACxDxBADxxxDABAxADDDBxACCxBCxDCAAxCDDxxBCxABBCBBDCACDAxBAxCDBDDDAAxBDDABCAAxCABBDDCBCxAACDDBDDCDADBAxDxDAxxDCCAADBAACAACDAxCBBxxCBxDxxxAxBAxDDAAADxAABBCxDAxDBAACADABDCDxDDBCDCADDABxACBBxBBBADABxCBxCAxxxCCABCAAABDDBBDxxDCBACCCBADDAxCBDDDBCBDDDCBACDDDADCDCADADADDCxCACADBADDAxADxxxDABBBDxCCxAAADBCDAxADCCBCDAAAxAxCAABBAxCxCADxCCxCBBADABDCACCADDDBxAxADACxDxAxDBDABxCACAxDDBDxDBxxDDCAxDBCxAxAAADDxBCxCAxDACDABCDxBBCDxDxCDCxxBDxDDBxADDCxBBxxxCDBDxDBxxDCxCBCCCBDDxBxxxxBDDBBCxCxCxBxBBAAADBxCADBDxxxBxAAADxACxxDABBDCDBCxBAAxxDDADDACxABxBDAxACxxDCxBCCBDxBDCDAABABCxDCxBDxDADxxCCDCBDCDxAAxBxCDxBBDBxCCxxDAAACxBDCCBAxADBABxBCADDCAADxCACAxBDxCADBABxCBBxBCxxACxxCABBCBxxBACDDDCDCxDxACxBBDCBBDDBCxBxCCAABCxAxACxBBxDACCCCAABCDDAxCDCACDBBBDCDxBBDCCACAAAACCDBCDxABCBCBBAABDDxBxxDCxAxBBAxAxABAABCBBCCxBDCBDAAAxCDxBDxDCDBDCxAxxDABCBxCBAxCABDxCCBACDBDDDxADCCCBCxCDABCAxxBCACxCxDDDCCCAADxDBABCADDDBBCxDCABCCAADxACBBCBxxAACxBBCADBABABCBDxCBBCxAABBBCADCBDBACxCAAADDDCBDCxBBCxADxAxDDAABDAADCDBCBDxxCACCCBDDBCCDDDAABCABDADBABxDDDACABBBxAAAAAxBCBCBxBDDCAxxDAxDDCBxxCxADDADDxCBxBABABDCDCAABCCxBBDxBxBxCxDxxBACBBBDCDCABACxxDCCDxDCxxAACAAxxABxDBxBDxxxBACDADDBxxxDACCxxBCABDxxxDACCBxACxBCDAxBCDCCADxDAABxADxABCCAxCAAAADDACCxxxBACDDDxCABAxDACCxCAAxDDxDBxCCBxDBAxBCCAAACCCDBDAxxCBDBADDABCBCADAxDADDxBCDDADBDDDDxxABACCxDACAxCBDxxDAACBCCCACCCCCACABADAxDBBDCCBCBxxBBBCxACCBCAxCDBBBBBAABxCAAADBBBAxCxxxAABBCCxDxxADCAAADBBADBDxxCBxBDCCCDDBCDxCAAAxBxBBAxDDDCBABBCDABADxAxCBDxAxDCCCxDxCCCAADDBADCADBCABxxDCBBBDBBxDADCDBBBCCxDCDxCxCCxAADBDxCCCDACBAxAACDCABxAAxxCAAxDxxCABCDDBAAAxCBBBCAxxCCADBDAxABADCCCDBBCCxBACCCAxDCDBxAxABDxxABDxCDBxCCDDAxAxDBCABACBDxDCDxCBDCCBABxxCCBBxCxxCACCBAABBBCDABDDCBCCBABxACDADDAADxxDBCDCBCDBxxDBBCxCxCAxxADACxABAACCxACCBCBxBxCDABAABAxBBBxCxACABDBxxDBBCxBAxACACxBAxxCDBxxBCBBBBBxxDCxBCDCxBBxABBCxACxDAxBxxADAxBBCADAADDDBBAAxCCAxDCCAAADDAADBCBAxDDxxAADCAAxDACDxAABDCADBDxBBDCDBxABADACABBBADDBCBxxDBxCCxAADDBxBxCCCBxBxDBDxABBCCxBBADxAAxABBAxCDBxABAAACCCBABAADBAxDADxBxACABABCBDCBAxABABBACDBDxCBCxCCCBxDDDABDxBAxAAAAxBCDxxBBADCDBDxABCBCBCCADBBxxxCDCxDBACBBCDBAxxABDCADADDBBDxDDAAxxBBBBCCDDDAABDCDDxCAxDBDCDCAxDxDxxCBBBBBxAxADCCACBBxCDDxDDBCxCCADADxCDBCAxDADAxBxBBBxDBAxBBBADDBABDADBxxBCxDACCBACDDADCxxCDCCDCACADBDDCBBDADxCBxBABACABDDCABAADAACxxCCxCBDDxDDDABCCDBxCCBCAADADABDCBCDDAAxCxxAABACDBxAxBxBCxxxAxCAxDDAACxCCxDCCCADCDDAxCBDAxBADxCABDxACDDDDBBBCBCDACxBxADCxCABBCxDBxxAxxBDBCADACBBxABADBxBCAxxBAAACACCBDDDxADCDxAxAxAxBxDBxDACAxxCBCBDBxxBBBxxADBAxAACxBBxCxABxADxAABxBCxBBDBCxAADxxDCxDxAxxDBBCBCDDBCDCABCxADADDCxxxDxCBCBBCxDCxxCxDDxAxxDxCCAxBDDDCxAxxDxABxCAACxAACAxAADBDBBCCxBADCCBCAADCBCCBAACDDBDBBDBABBDxxCBBADBCBADDADBDCCxxxDxxAABAAxCBxDDCACCBAxBACBBBxxDBCxBBBCBAADCACABBxDBCCxCACDCDxxCBAxCDADCABBBBAxBADCCACxACDxBDCxBBxDDCxBCBDDDBCxxDCBBAxCBxxBDBDABCBAxDABxxCCDABACxDABCDAACxDBACCBDCCDDBCABAxxDCxBxBADDABxBxBAAAxxAABABDBACABDDBCxBAxDxCxDBCCBBBBBCBDABBDDAABBDCBBxABBxxABBDBCCCBAAADCCDxDCCxABCxDBDxxBDDCDAxBDADxCDCAAxBAxBxxBAAADBxxACBxDxDxDACCADDCDDxBxDDAxDDADDDCxCxxBAxBBDxDCACACABDAAABBCBBxDABABBxDBACDxBBDAAxBABAABDxCACxDADADCABDDxBBBBDCAxxxBxBACDxCCDCADBBxxACADxAxxCDDACxBxCDBDxxxCxCCDABABADBAAxCACBBCBxBCDDxBDxDAADCxAADAxBBDDDBDBABACDxAAxCCBxxBABBDBxxxADxxBDxBxCDCABDDBDDDBxCxBCAxBxCxABADDBCCDBCCDBAxAADDCCCADACBDCABxxBxxxCDBBBABBDCDxDBxACDBADCBBBDxBCDxCABDAxxCCxDDBxBCACCDxDADCCDADDAACBCxDBxCDxDBxDADBBACBADCDCBCADBCBCDDBADACDDCDxBADDCACBBCxBDxBxCBDDxBABBCBAxCCBBDCxCBABCCCDDxACBABxBAAABDDCCDxCCxDABCAABBCABDDxBCCxBBxBBxCBAAxxDBBDxABAxxDDCACxDDCxDAADADBAAxCCxxBCCBCxBxCxDACAADABxxDABBxABBDBABDCBxACxADxBBBCDxAxCCxBBxADBCDDCxBDBxAxAxDACCCAAxxCACxCBxDDxDBACCCCDBCBCBBDxxAxADABACBACBCCABBAxDxAADCCBCBxCxBBCBCxDDCDDCACxxBCBCBCDDxACAxxxBADDCCDxCADAACCDDxxAAACDDBADDBABDDxCCCACDADxxxCCCACxAAAAxADABADxCDDxxBBADxDDxxCCBxBxAAACxDxADAAxDBCxCBACBDCDADxDBCCBCDxCBACCxCDxAxxxAADDBBxCDxDxCxDBBxBBBDBDDADCACDDADADBDxAxCADCBDDxxBCCCAACDBDxxxBxAAxABBDxAxBBBBAxCDxCBAxAxCxxBCCDAxDDDCCxCCCBxBADxCCDBxBDAxAxxACDDBxAABBAAxxBAxDBxAADAxxBBDBDADACDCxBDxACBCxAxDADDCCCxDABxABDCADCxxDACCDDBDCDDAxxCDxDBBAxBxBCBCAADBBCABAAABxxAxBCABxCCCADBADABDABBACDACCABCxDxCCCxADxBBBCDDACCxDADDxDxAxDDDDCCDAACxACxCCDAxBAABBxBxBxDDAAADCxCxABxDBDADAAxBBBxABxCAACBBCDAAxBDBDCABxDxxDCABCDDxxDDAAADBAxCBAADBDxACxABAADCBAADDABxDADxABCABxADxxBCCxCxBADAxDBxCDDCACCAACxBBBACxBACBDAAxDDCxDCCCACCBDCxxxBBADCCCCxCBxBADACDCxCAAxxBDDACBCBxAAxxDBDDACxDACBDBxDDBxBBBABCBAxxxCBxCABDDABxxABBDBAABBABCBxDBDxCDxCBCCCCxxADDxDBxCDAADBDADCDCAABDCBxBCxAADCCxBxADCxAxxDDADDDCCxAxxCAACADBBxxCACDACCDACCxBBxxAACCBBxCBCDAABBBDCDxCADDCDCADxBxAxAADCAADCAxBACCCACxxAxDxBBBxDBACBDxAABBAxxBBxBBBCBCCDDDxDCCAxDxCAxBCCAABDAAAxABAxCBCAADCAxDDBCBABBxDxxBCACxxDABCDCDACxBBAAACCBBBDDBCDCBCCxCADCxBCBxBBCxCCxCBCxADAxCAxxACDxACCCxBCABBxCABDDxxAADxxAAACCxCCADCCBCCBBBDxBCADCDBDADCCCBDBBCDAxxBBBxCBxDACAxCAADBBDCBCCCCDABxxBBCCBACADxDBDDABAxxDAAxCCCCAAAxCBBDCACCBADxBDxBCDBDDCBxxCBxBDxBBACBABxxADDACAAxBxAAACCDxCDDDBxBDDDCBxBACDADBDADDxAAxxxCxCBCDxxAADBACxBDBxCBDACDBBxBADCDADCCxABCBxDADDBBCxDCAxABxxDBBCxCDACBCxCBDxBBBDCCBCCBCAxDDBBCDDxDxAxBxBAxACCCAxxxDDxCDDAABACxCxxxxBACDDCAACDDDCCDDCxDxDBACAABADDBDDBDBxxxCACCxCCxCBBxBAxCxxDBABDCxDBxCDBDDACBCAAxxADAxDxBxDxDxDADCxBDCAxDDABxDCDABDAxCBDCBxDCDBAAABDACCAADCCxCCxCBCxDCCBDBCADxBBABDAxCBDxBCDDBBDCAAABDxBxDCBADxDCBxxBAAABCABBAxCBDBCAACxxCxBDxDAxDAAxCCxBBxDAxDCBADAxCxBDAxACAxCAADDBADBBxxDDDDCBCxCCxBCAABCxxCxABAxDDADADxBxxBACDABDxAxCDBAxDAACCBACBDDxCADxAxCxBBBCDABDACDAAAACCCBxAABBxDCCBABCDABBBCCABCBDAADCxDBBCCBBDADCCBCxCCBxADAxDxCDBAxABABxxCxxAxABCCDxDCBBAAAxCCABABCCCBDxxDAxCBxDDDDBxAxDAxACCDADCDCACxCxCxBDAxBAACDxADxDxDBBBxCACDAACDADBADCACxAABxADDCCDCAxxCBADACxDCxBDAAAACDxBCCxCDxCCADADAxBDxBBBCDCDxxxBADADDCAAACDBBBxBxAxDACBABABDAACCDxCAADxAABDxxxDxxDDBCxxxxxxDACDxCDDAxBDCCBxBBBDBBCxxBBDBCCCxxAAxCxxxAxBBBBxBDCCCxCxDDBAADBBDDAAxxCxBxCDBxCBCCDAACxDBxBBDCBCACCBxxAACDxCBxAxDBBAACCACBAAACDxxDCBCBAAAxCxDDCxxAACBBCDBACAABBxBxAxxCBxBDCBxBCDAxBDBACDBBDADxxAxxxBAxCxxxCxDBABCAABAxAxxDDABBCCADBAADBCABxACCxCDCxCxDxDCxDDxAAAADBBDACCCAAADACADAABCCxABDxxCAACDDBDDxDDBACBCCDBAADxxCCBDDCBDBDDCDxBxxBABxADBxDADCCxxxBCxACDAxABACBCBCDxxDDBACDAADBBCBAADBxBBCCBBACxADADxAACCCACxDxxBDADxCBDBxxDxDxCABxCABDxxBBCAxDxADDBxCDBACADCxCBABADDDDxAxDACBCxCCxAAxBBADxBBDABBBCAxxDCAABBCCAxBCxCxxBCABCxAACxDCAxBCxxDBDDCCxDDBDAxAxCBBCDAxCCAABxABAAAxBCCCDCBDCBCACAxABBACCAxBCAxDCDAxADABDxABxDDCxBBDDBCBCCACDBBBDxACDxABCDxBCAADCABxxCDBBxxxxABCAxDADBBxCCDBxxDABxDCDAxACABDBACDAABxDDxBxxxxDxAABBCABAAxCDBAACCCDBDxCCDACCAADDACxCCCBBCxCxCCDCACBxxBDBxBDDCxBDDAxDDACBDDDBABCDDBAAxCCDxBDAAAxBAABDxCxDBACCDxBxAxBxCAACxCCDBBDxxBBDCBBBADCxAxBDxCCBBxADDCDAxxxxBCABxxABCDAxACBADAxBxCDCBAxDBxDDCCCDABxDCAABAADCDxDDCBDxAABCDxCBCxAxCAAAxAAxxDxBDBDACDBBCxCBCCBACDBxDCBxCADBCDACBABADDDCxxAACxCBCAxBxDDBBBxAxxABCxxCDBxACDBAABDDxACDxBCxADxxCCDCxDCCCxDADDDxDBACxACxCCDDBBDDBCBxCCABxxAxAADCxDBCxxxxDAAADBxADxADCAAxCBCxxDADDDBDxDCBBxBBBBxADDxxDDxBBBBBAABABBDBBDAADBCDDxBBBDBxDCBCCDxBxAxBxACBxAAxDCCCACCAADxCxBACADDACBACACDxDBxxAxxCDBBDCBCAxBxDxADBADxBDCCBABCCxCDCxDDxDxxBBxDxxDAABCDACAxxCCDDAxxDBDCCDCCBAAABDCABADBCAxCADCCCCxCACxDxxCADCxCCCxADDAABCDCBDDCCBCCDAxxBCACBDCBCDBCBDCxxxCAxBBDAADBDxACACDADBADBBABBCBDxADBxDAxBBBDDCACDADABCADDCBDDxDBBBxDDCBBDBDxBADABADAxDxDBDxDxBxxAxADDDBBxDBDCxCCBCDCxxxxCCCDBBBxDDCCBxCCxCCADACDCBxDxxCBDBCCBBADCCxBDDAAxxxxxxCxCDACACCxABADBBBDCxDxCDAAACDABACxBxCCBDxCCxCxBDCDxAAxDxxDxxAxBCBCDDDBDCDxBxCAABCBBDAxABDBCxADCxCDBAAAxxCBABxBBxDCABBAxBBDBACAABCCBxxCDAxxDBCAxAACACAxCDBBDCxBAxxBDxx"
    # "xBxAAABCDxCC"
  end

  def solve do
    input()
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.map(fn group -> Enum.filter(group, &(&1 != "x")) end)
    |> Enum.reduce(0, fn group, acc -> score_of(group) + acc end)
  end

  defp score_of(group) do
    group |> IO.inspect(label: "group")

    score =
      case group do
        [c1, c2, c3] -> score_of(c1, 2) + score_of(c2, 2) + score_of(c3, 2)
        [c1, c2] -> score_of(c1, 1) + score_of(c2, 1)
        [c] -> score_of(c, 0)
        [] -> 0
      end

    score |> IO.inspect(label: "score")
  end

  defp score_of("A", add), do: add
  defp score_of("B", add), do: 1 + add
  defp score_of("C", add), do: 3 + add
  defp score_of("D", add), do: 5 + add
end

# Part1.solve() |> dbg()
# Part2.solve() |> dbg()
Part3.solve() |> dbg()