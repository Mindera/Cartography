import Cartography

import Nimble
import Quick

class DistributeSpec: QuickSpec {
    override func spec() {
        var window: TestWindow!
        var viewA: TestView!
        var viewB: TestView!
        var viewC: TestView!

        beforeEach {
            window = TestWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

            viewA = TestView(frame: CGRect.zero)
            window.addSubview(viewA)

            viewB = TestView(frame: CGRect.zero)
            window.addSubview(viewB)

            viewC = TestView(frame: CGRect.zero)
            window.addSubview(viewC)

            constrain(viewA, viewB, viewC) { viewA, viewB, viewC in
                viewA.width  == 100
                viewA.height == 100

                viewA.top  == viewA.superview!.top
                viewA.left == viewA.superview!.left

                viewA.size == viewB.size
                viewA.size == viewC.size
            }
        }
        
        func testLeftToRightConstraints() {
            it("should distribute the views") {
                expect(viewA.frame.minX).to(equal(  0))
                expect(viewB.frame.minX).to(equal(110))
                expect(viewC.frame.minX).to(equal(220))
            }
            
            it("should disable translating autoresizing masks into constraints") {
                expect(viewA).notTo(translateAutoresizingMasksToConstraints())
                expect(viewB).notTo(translateAutoresizingMasksToConstraints())
                expect(viewC).notTo(translateAutoresizingMasksToConstraints())
            }
        }
        
        func testVerticalConstraints() {
            it("should distribute the views") {
                expect(viewA.frame.minY).to(equal(  0))
                expect(viewB.frame.minY).to(equal(110))
                expect(viewC.frame.minY).to(equal(220))
            }
            
            it("should disable translating autoresizing masks into constraints") {
                expect(viewA).notTo(translateAutoresizingMasksToConstraints())
                expect(viewB).notTo(translateAutoresizingMasksToConstraints())
                expect(viewC).notTo(translateAutoresizingMasksToConstraints())
            }
        }

        describe("from left to right") {
            beforeEach {
                constrain(viewA, viewB, viewC) { viewA, viewB, viewC in
                    align(centerY: viewA, viewB, viewC)
                    distribute(by: 10, leftToRight: viewA, viewB, viewC)
                }

                window.layoutIfNeeded()
            }

            testLeftToRightConstraints()
        }
        
        describe("from left to right with layout proxy array") {
            beforeEach {
                constrain([viewA, viewB, viewC]) { views in
                    align(centerY: views)
                    distribute(by: 10, leftToRight: views)
                }
                
                window.layoutIfNeeded()
            }
            
            testLeftToRightConstraints()
        }

        describe("vertically") {
            beforeEach {
                constrain(viewA, viewB, viewC) { viewA, viewB, viewC in
                    align(centerX: viewA, viewB, viewC)
                    distribute(by: 10, vertically: viewA, viewB, viewC)
                }

                window.layoutIfNeeded()
            }

            testVerticalConstraints()
        }
        
        describe("vertically with layout proxy array") {
            beforeEach {
                constrain([viewA, viewB, viewC]) { views in
                    align(centerX: views)
                    distribute(by: 10, vertically: views)
                }
                
                window.layoutIfNeeded()
            }
            
            testVerticalConstraints()
        }
    }
}
