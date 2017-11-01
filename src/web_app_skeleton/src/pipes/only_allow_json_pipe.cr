module OnlyAllowJsonPipe
  macro included
    before only_allow_json
  end

  private def only_allow_json
    if json?
      continue
    else
      json({error: "Must have Content-Type header set to application/json"}, status: 415)
    end
  end
end
