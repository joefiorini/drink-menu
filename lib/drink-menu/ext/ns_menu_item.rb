class NSMenuItem
  attr_accessor :rac_command
  attr_accessor :rac_originalTarget
  attr_accessor :rac_stateSignal

  def rac_command=(command)

    @rac_command = command

    self.enabled = (command && command.canExecute) || true

    return unless command

    # TODO: Set state via binding rather than validateMenuItem
    # Look at https://github.com/ReactiveCocoa/ReactiveCocoa/blob/2.0-development/ReactiveCocoaFramework/ReactiveCocoa/NSObject%2BRACAppKitBindings.m#L23
    #
    self.bind(NSEnabledBinding, toObject: self.rac_command, withKeyPath: "canExecute", options: nil)

    self.rac_hijackActionAndTargetIfNeeded

    @rac_command
  end

  def rac_stateSignal=(signal)
    @rac_stateSignal = signal
    @rac_stateSignal.subscribeNext ->(value){
      self.state = value
    }
  end

  def rac_hijackActionAndTargetIfNeeded
    hijackSelector = :"rac_commandPerformAction:"

    return if target == self and action == hijackSelector

    NSLog("WARNING: NSControl.rac_command hijacks the control's existing target and action. You can access the original target via the rac_originalTarget property.") if target

    self.rac_originalTarget = target

    self.target = self
    self.action = hijackSelector
  end

  def rac_commandPerformAction(sender)
    rac_command.execute(sender)
  end

  def validateMenuItem(item)
    return rac_originalTarget.validateMenuItem(item) if rac_originalTarget and rac_originalTarget.respondsToSelector(:"validateMenuItem:")

    rac_command.canExecute
  end

end

