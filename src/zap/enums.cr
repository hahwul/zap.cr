module Zap
  # ZAP alert risk levels, matching the integer IDs ZAP uses in its API
  # (`riskId`). Higher value means higher risk.
  #
  # These are accepted anywhere an alert is filtered by risk; the existing
  # `Int32` / `String` based API keeps working unchanged.
  enum Risk
    Informational = 0
    Low           = 1
    Medium        = 2
    High          = 3

    # ZAP's `riskId` query parameter value for this level.
    def id : Int32
      value
    end

    def to_param : String
      value.to_s
    end
  end

  # ZAP alert confidence levels, matching the integer IDs ZAP uses in its API
  # (`confidenceId`).
  enum Confidence
    FalsePositive = 0
    Low           = 1
    Medium        = 2
    High          = 3
    UserConfirmed = 4

    # ZAP's `confidenceId` query parameter value for this level.
    def id : Int32
      value
    end

    def to_param : String
      value.to_s
    end
  end

  # Normalizes a risk argument that may be either a raw ZAP `riskId` `Int32`
  # (with `-1` meaning "no filter") or a `Zap::Risk` enum, into the `Int32`
  # value ZAP expects.
  def self.risk_id(risk : Int32 | Zap::Risk) : Int32
    risk.is_a?(Zap::Risk) ? risk.id : risk
  end

  # Normalizes a confidence argument that may be either a raw ZAP
  # `confidenceId` `Int32` or a `Zap::Confidence` enum, into the `Int32` value
  # ZAP expects.
  def self.confidence_id(confidence : Int32 | Zap::Confidence) : Int32
    confidence.is_a?(Zap::Confidence) ? confidence.id : confidence
  end
end
