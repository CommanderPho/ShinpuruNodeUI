//
//  ShinpuruNodeDataTypes.swift
//  ShinpuruNodeUI
//
//  Created by Simon Gladman on 01/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit

/// Node value object

open class SNNode: Equatable, Hashable
{
    let uuid  = UUID()
    
    open var numInputSlots: Int = 0
    open var inputs: [SNNode?]?
    var position: CGPoint
    public var name: String
    
    public required init(name: String, position: CGPoint)
    {
        self.name = name
        self.position = position
    }
    
    public var hashValue: Int
    {
        return uuid.hashValue
    }
    
    public func isAscendant(_ node: SNNode) -> Bool // TO DO test long chain
    {
        guard let inputs = inputs else
        {
            return false
        }
        
        for inputNode in inputs
        {
            if inputNode == node
            {
                return true
            }
            else if inputNode != nil && inputNode!.isAscendant(node)
            {
                return true
            }
        }
        
        return false
    }
}

public func == (lhs: SNNode, rhs: SNNode) -> Bool
{
    return (lhs.uuid == rhs.uuid)
}

/// Node Pair - used as a dictionary key in relationship curves layer

struct SNNodePair: Equatable, Hashable
{
    let sourceNode: SNNode
    let targetNode: SNNode
    let targetIndex: Int
    
    var hashValue: Int
    {
        return sourceNode.uuid.hashValue + targetNode.uuid.hashValue + targetIndex.hashValue
    }
}

func == (lhs: SNNodePair, rhs: SNNodePair) -> Bool
{
    return lhs.sourceNode == rhs.sourceNode && lhs.targetNode == rhs.targetNode && lhs.targetIndex == rhs.targetIndex
}

/// SNView delegate protocol

public protocol SNDelegate: NSObjectProtocol
{
    func dataProviderForView(_ view: SNView) -> [SNNode]?
    
    func itemRendererForView(_ view: SNView, node: SNNode) -> SNItemRenderer
    
    func inputRowRendererForView(_ view: SNView, inputNode: SNNode?, parentNode: SNNode, index: Int) -> SNInputRowRenderer
    
    func outputRowRendererForView(_ view: SNView, node: SNNode) -> SNOutputRowRenderer
    
    func nodeSelectedInView(_ view: SNView, node: SNNode?)
    
    func nodeMovedInView(_ view: SNView, node: SNNode)
    
    func nodeCreatedInView(_ view: SNView, position: CGPoint)
    
    func nodeDeletedInView(_ view: SNView, node: SNNode)
    
    func relationshipToggledInView(_ view: SNView, sourceNode: SNNode, targetNode: SNNode, targetNodeInputIndex: Int)
    
    func defaultNodeSize(_ view: SNView) -> CGSize
    
    func nodesAreRelationshipCandidates(_ sourceNode: SNNode, targetNode: SNNode, targetIndex: Int) -> Bool 
}

/// Base class for node item renderer

open class SNItemRenderer: UIView
{
    open weak var node: SNNode?
    
    required public init(node: SNNode)
    {
        self.node = node
        
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func reload()
    {
        fatalError("reload() has not been implemented")
    }
}

/// Base class for output row renderer

open class SNOutputRowRenderer: UIView
{
    public weak var node: SNNode?
    
    public required init(node: SNNode)
    {
        self.node = node
        
        super.init(frame: .zero)
    }
    
    open func reload()
    {
        fatalError("reload() has not been implemented")
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Base class for input row renderer

open class SNInputRowRenderer: UIView
{
    public var index: Int
    
    public unowned let parentNode: SNNode
    open weak var inputNode: SNNode?
    
    required public init(index: Int, inputNode: SNNode?, parentNode: SNNode)
    {
        self.index = index
        self.inputNode = inputNode
        self.parentNode = parentNode
        
        super.init(frame: .zero)
    }

    open func reload()
    {
        fatalError("reload() has not been implemented")
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    required public init(node: SNNode)
    {
        fatalError("init(node:) has not been implemented")
    }
}





